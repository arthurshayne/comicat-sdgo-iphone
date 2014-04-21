//
//  GDHomeViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/21/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDHomeViewController.h"

@interface GDHomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *carouselScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *carouselPageControl;
@property (weak, nonatomic) IBOutlet UILabel *carouselLabel;

@property (strong, nonatomic) NSTimer *timer;

@property int carouselPosition;
@property (strong, nonatomic) NSArray *images;  // of UIImage
@property (strong, nonatomic) NSArray *imageViews;  // of UIImageView, 3 of them
@end

@implementation GDHomeViewController

BOOL pageControlBeingUsed;

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

- (NSArray *) imageViews {
    if (!_imageViews) {
        _imageViews = @[[[UIImageView alloc] init], [[UIImageView alloc] init], [[UIImageView alloc] init]];
    }
    return _imageViews;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // prepare carousel
    for (int i = 0; i < self.imageViews.count; i++) {
        CGRect frame;
        frame.origin.x = self.carouselScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.carouselScrollView.frame.size;

        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        imageView.frame = frame;
        [self.carouselScrollView addSubview:imageView];
    }
    
    [self loadImagesIntoImageViews];
    
    self.carouselScrollView.contentSize =
        CGSizeMake(self.carouselScrollView.frame.size.width * self.images.count,
                   self.carouselScrollView.frame.size.height);

    self.carouselScrollView.pagingEnabled = YES;
    self.carouselScrollView.delegate = self;

    // paging control
    self.carouselPageControl.numberOfPages = self.images.count;
    self.carouselPageControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;

    // setup timer
    [self resetAndSetupTimer];
}

// for carousel
- (void) nextPage {
    self.carouselPosition = (++self.carouselPosition) % self.images.count;
}

// for carousel
- (void) previousPage {
    self.carouselPosition = (--self.carouselPosition + self.images.count) % self.images.count;
}

- (void) loadImagesIntoImageViews {
    // utilize current page number
    int prev = (self.carouselPosition == 0) ? self.images.count - 1 : self.carouselPosition - 1;
    int next = (self.carouselPosition == self.images.count - 1) ? 0 : self.carouselPosition + 1;
    int curr = self.carouselPosition;
    
    NSLog(@"%d %d %d", prev, curr, next);
    
    UIImageView *prevView = [self.imageViews objectAtIndex:0];
    [prevView setImage:[self.images objectAtIndex:prev]];
    
    UIImageView *currView = [self.imageViews objectAtIndex:1];
    [currView setImage:[self.images objectAtIndex:curr]];
    
    UIImageView *nextView = [self.imageViews objectAtIndex:2];
    [nextView setImage:[self.images objectAtIndex:next]];
    
    [self.carouselScrollView scrollRectToVisible:CGRectMake(self.carouselScrollView.frame.size.width, 0, self.carouselScrollView.frame.size.width, self.carouselScrollView.frame.size.height) animated:NO];
}

- (void) resetAndSetupTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleSchedule) userInfo: nil repeats:YES];
}

- (void) handleSchedule {
    [self.carouselScrollView setContentOffset:CGPointMake(self.carouselScrollView.frame.size.width * 2, 0)
                                     animated:YES];
    [self nextPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePage:(id)sender {
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resetAndSetupTimer];
    
    self.carouselPageControl.currentPage = self.carouselPosition;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; // disable animated changes
    
    if (scrollView.contentOffset.x > scrollView.frame.size.width) {
        // We are moving forward. Load the current doc data on the first page.
        [self nextPage];
        [self loadImagesIntoImageViews];
    } else if (scrollView.contentOffset.x < scrollView.frame.size.width) {
        [self previousPage];
        [self loadImagesIntoImageViews];
    }
    [CATransaction commit];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
    
    [self loadImagesIntoImageViews];
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
