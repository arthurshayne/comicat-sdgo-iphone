//
//  GDHome2ViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/22/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDHome2ViewController.h"
#import "GDManager.h"
#import "GDCommunicator.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CarouselInfo.h"
#import "HomeInfo.h"

@interface GDHome2ViewController ()
//@property (strong, nonatomic) NSArray *images;  // of UIImage
@property (strong, nonatomic) HomeInfo *homeInfo;

@property (strong, nonatomic) UILabel *carouselLabel;
@property (strong, nonatomic) UIPageControl *carouselPageControl;
@property (strong, nonatomic) GBInfiniteScrollView *infiniteScrollView;
@end

@implementation GDHome2ViewController

GDManager *manager;
HomeInfo *homeInfo;

//- (NSArray *) images {
//    if (!_images) {
//        _images = @[[UIImage imageNamed:@"1"],
//                    [UIImage imageNamed:@"2"],
//                    [UIImage imageNamed:@"3"],
//                    [UIImage imageNamed:@"4"],
//                    [UIImage imageNamed:@"5"]];
//    }
//    return _images;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    manager = [[GDManager alloc] init];
    manager.communicator = [[GDCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.delegate = self;
    
    // Add label and page control (as indicator)
    CGRect labelFrame = CGRectMake(0, 243, 320, 21);
    self.carouselLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    self.carouselLabel.textColor = [UIColor whiteColor];
    self.carouselLabel.backgroundColor = [UIColor blackColor];
    self.carouselLabel.opaque = false;
    self.carouselLabel.alpha = 0.7;
    [self.carouselLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.carouselLabel setFont:[UIFont systemFontOfSize:12]];
    
    [self.view addSubview:self.carouselLabel];
    
    CGRect pageControlFrame = CGRectMake(200, 235, 120, 37);
    self.carouselPageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    [self.view addSubview:self.carouselPageControl];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // get home info
    [manager fetchHomeInfo];
    
    [self prepareCarousel];
}

- (void) prepareCarousel {
    CGRect carouselFrame = CGRectMake(0, 64, 320, 200);
    
    self.infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:carouselFrame];
    
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    
    self.infiniteScrollView.pageIndex = 0;
    
    [self.view addSubview:self.infiniteScrollView];
}


#pragma mark - GDManagerDelegate

- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo {
//     NSLog(@"%c", homeInfo.success);
    
    self.homeInfo = homeInfo;
    
    [self.infiniteScrollView reloadData];
    [self.infiniteScrollView startAutoScroll];
    
    [self updatePageControlAccordingly];
    
    [self.view bringSubviewToFront:self.carouselLabel];
    
    self.carouselPageControl.numberOfPages = homeInfo.carousel.count;
    [self.view bringSubviewToFront:self.carouselPageControl];
}

- (void)fetchingHomeInfoWithError:(NSError *)error {
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

#pragma mark - GBInfiniteScroll

- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Next page");
    [self updatePageControlAccordingly];
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Previous page");
    [self updatePageControlAccordingly];
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    if (self.homeInfo) {
        return self.homeInfo.carousel.count;
    } else {
        return 0;
    }
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index {
    NSLog(@"pageAtIndex:%lu", (unsigned long)index);
    
    if (!self.homeInfo) {
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, infiniteScrollView.bounds.size.width, infiniteScrollView.bounds.size.height);
    
//    UIImage *image = [self.images objectAtIndex:index];

    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:frame
                                                         style:GBInfiniteScrollViewPageStyleText];
    }
    
//    page.textLabel.text = record.text;
//    page.textLabel.textColor = record.textColor;
//    page.contentView.backgroundColor = record.backgroundColor;
//    page.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:128.0f];
    
    CarouselInfo *ci = (CarouselInfo*)[self.homeInfo.carousel objectAtIndex:index];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImageWithURL:[NSURL URLWithString:ci.imageURL]];
    
    [page.contentView addSubview:imageView];
    
    
    return page;
}

- (void) updatePageControlAccordingly {
    int pageIndex = self.infiniteScrollView.currentPageIndex;
    
    CarouselInfo *ci = (CarouselInfo*)[self.homeInfo.carousel objectAtIndex:pageIndex];
    
    // update the label
    self.carouselLabel.text = ci.title;
    self.carouselPageControl.currentPage = pageIndex;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
