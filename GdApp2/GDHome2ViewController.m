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
#import "GDInfoBuilder.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CarouselInfo.h"
#import "HomeInfo.h"
#import "MBProgressHUD.h"
//#import "UIScrollView+SVPullToRefresh.h"
#import "AAPullToRefresh.h"

@interface GDHome2ViewController ()

//@property (strong, nonatomic) NSArray *images;  // of UIImage
@property (strong, nonatomic) HomeInfo *homeInfo;


@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

@property (weak, nonatomic) IBOutlet GBInfiniteScrollView *infiniteScrollView;
@property (weak, nonatomic) IBOutlet UILabel *carouselLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *carouselPageControl;

@property (weak, nonatomic) AAPullToRefresh *aaptr;
@end

@implementation GDHome2ViewController

GDManager *manager;

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    manager = [[GDManager alloc] init];
    manager.communicator = [[GDCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.delegate = self;
  
    self.carouselLabel.textColor = [UIColor whiteColor];
    self.carouselLabel.backgroundColor = [UIColor blackColor];
    self.carouselLabel.opaque = false;
    self.carouselLabel.alpha = 0.7;
    [self.carouselLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.carouselLabel setFont:[UIFont systemFontOfSize:12]];
    
    // TODO: animation, hide the view
    self.view.hidden = YES;
    
    self.rootScrollView.contentSize = CGSizeMake(320, 20000);
    
    self.aaptr = [self.rootScrollView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        // do something...
        // then must call stopIndicatorAnimation method.
        [manager fetchHomeInfo];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // get home info
    [manager fetchHomeInfo];
}

- (void) prepareCarousel {
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    
    [self.infiniteScrollView reloadData];
    [self.infiniteScrollView startAutoScroll];

    self.infiniteScrollView.pageIndex = 0;
}

- (IBAction)updateButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // get home info
    [manager fetchHomeInfo];
}

#pragma mark - GDManagerDelegate

- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo {
    NSLog(@"didReceiveHomeInfo");
    
    self.homeInfo = homeInfo;
    
    [self prepareCarousel];
    
    [self.view bringSubviewToFront:self.carouselLabel];
    
    self.carouselPageControl.numberOfPages = homeInfo.carousel.count;
    [self.view bringSubviewToFront:self.carouselPageControl];
    
    self.view.hidden = NO;
   
    [self updatePageControlAccordingly];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    [self.aaptr performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0];
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
    NSLog(@"infiniteScrollView:pageAtIndex:%lu", (unsigned long)index);
    
    if (!self.homeInfo) {
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, infiniteScrollView.bounds.size.width, infiniteScrollView.bounds.size.height);
    
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
    imageView.tag = index;
    
    imageView.userInteractionEnabled = YES;
    
    // TODO: bind tap event
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carouselTapped:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];

    [page.contentView addSubview:imageView];
    
    return page;
}

- (void) carouselTapped:(UITapGestureRecognizer *)gesture {
    
}

- (void) updatePageControlAccordingly {
    int pageIndex = self.infiniteScrollView.currentPageIndex;
    
    CarouselInfo *ci = (CarouselInfo*)[self.homeInfo.carousel objectAtIndex:pageIndex];
    
    // update the label
    self.carouselLabel.text = ci.title;
    self.carouselPageControl.currentPage = pageIndex;
    
    NSLog(@"updatePageControlAccordingly %d %@", pageIndex, ci.title);
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
