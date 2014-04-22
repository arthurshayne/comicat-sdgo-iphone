//
//  GDHome2ViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/22/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDHome2ViewController.h"

@interface GDHome2ViewController ()
@property (strong, nonatomic) NSArray *images;  // of UIImage
@end

@implementation GDHome2ViewController

- (NSArray *) images {
    if (!_images) {
        _images = @[[UIImage imageNamed:@"1"],
                    [UIImage imageNamed:@"2"],
                    [UIImage imageNamed:@"3"],
                    [UIImage imageNamed:@"4"],
                    [UIImage imageNamed:@"5"]];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    // prepare carousel
    CGRect carouselFrame;
    carouselFrame.origin.x = 0;
    carouselFrame.origin.y = 64;
    carouselFrame.size.width = 320;
    carouselFrame.size.height = 200;
    
    GBInfiniteScrollView *infiniteScrollView = [[GBInfiniteScrollView alloc] initWithFrame:carouselFrame];
    
    infiniteScrollView.infiniteScrollViewDataSource = self;
    infiniteScrollView.infiniteScrollViewDelegate = self;
    
    infiniteScrollView.pageIndex = 0;
    
    [self.view addSubview:infiniteScrollView];
    
    [infiniteScrollView reloadData];
    
    [infiniteScrollView startAutoScroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GBInfiniteScroll Category

- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Next page");
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
    NSLog(@"Previous page");
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView
{
    return self.images.count;
}

- (GBInfiniteScrollViewPage *)infiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView pageAtIndex:(NSUInteger)index;
{
    NSLog(@"pageAtIndex:%d", index);
    
    CGRect frame;
    frame.origin.x = frame.origin.y = 0;
    frame.size = infiniteScrollView.bounds.size;
    
    UIImage *image = [self.images objectAtIndex:index];
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (page == nil) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:frame
                                                         style:GBInfiniteScrollViewPageStyleText];
    }
    
//    page.textLabel.text = record.text;
//    page.textLabel.textColor = record.textColor;
//    page.contentView.backgroundColor = record.backgroundColor;
//    page.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:128.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    
    [page.contentView addSubview:imageView];
    
    return page;
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
