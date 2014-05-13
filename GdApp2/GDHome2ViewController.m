//
//  GDHome2ViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/22/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDHome2ViewController.h"

#import "GDManagerFactory.h"
#import "GDManager.h"
#import "GDInfoBuilder.h"
#import "Utility.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "AAPullToRefresh.h"
#import "MBProgressHUD.h"
#import "NSDate+PrettyDate.h"

#import "CarouselInfo.h"
#import "VideoListItem.h"
#import "HomeInfo.h"

#import "GDVideoViewController.h"
#import "GDPostViewController.h"

#import "GDPostCategoryView.h"

@interface GDHome2ViewController ()

//@property (strong, nonatomic) NSArray *images;  // of UIImage
@property (strong, nonatomic) HomeInfo *homeInfo;

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

@property (weak, nonatomic) IBOutlet GBInfiniteScrollView *infiniteScrollView;
@property (weak, nonatomic) IBOutlet UILabel *carouselLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *carouselPageControl;

@property (weak, nonatomic) AAPullToRefresh *aaptr;

@property (weak, nonatomic) IBOutlet UICollectionView *videoListCollectionView;

@end

@implementation GDHome2ViewController

GDManager *manager;
int postIdForSegue;

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    manager = [GDManagerFactory getGDManagerWithDelegate:self];
    
    self.carouselLabel.textColor = [UIColor whiteColor];
    self.carouselLabel.backgroundColor = [UIColor blackColor];
    self.carouselLabel.opaque = false;
    self.carouselLabel.alpha = 0.7;
    [self.carouselLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.carouselLabel setFont:[UIFont systemFontOfSize:14]];
    
    // TODO: animation, hide the view
//    self.view.hidden = YES;
    
    self.aaptr = [self.rootScrollView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        NSLog(@"aaptr fetchHomeInfo");
        // do something...
        [manager fetchHomeInfo];
        // then must call stopIndicatorAnimation method.
    }];
    // don't display at once
    [self.aaptr stopIndicatorAnimation];
    self.aaptr.imageIcon = [UIImage imageNamed:@"halo"];
    self.aaptr.threshold = 60.0f;
    self.aaptr.borderWidth = 0;
    
    [self.videoListCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"VideoListCell"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // get home info
    NSLog(@"selfDidLoad fetchHomeInfo");
    [manager fetchHomeInfo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    [super viewWillAppear:animated];

    [self.infiniteScrollView startAutoScroll];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.infiniteScrollView stopAutoScroll];
}

- (void)prepareCarousel {
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    
    [self.infiniteScrollView reloadData];
    [self.infiniteScrollView startAutoScroll];

    self.infiniteScrollView.pageIndex = 0;
}


- (void) prepareVideoList {
    self.videoListCollectionView.dataSource = self;
    self.videoListCollectionView.delegate = self;
    
    CGRect frame = self.videoListCollectionView.frame;
    frame.size.height = 135 * self.homeInfo.videoList.count / 2;
    [self.videoListCollectionView setFrame: frame];
    self.videoListCollectionView.contentSize = frame.size;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewVideo"]) {
        if ([segue.destinationViewController isKindOfClass:[GDVideoViewController class]]) {
            GDVideoViewController *gdpvc = (GDVideoViewController *)segue.destinationViewController;
            gdpvc.postId = postIdForSegue;
            gdpvc.hidesBottomBarWhenPushed = YES;
        }
    } else if([segue.identifier isEqualToString:@"ViewPost"])  {
        if ([segue.destinationViewController isKindOfClass:[GDPostViewController class]]) {
            GDVideoViewController *gdvvc = (GDVideoViewController *)segue.destinationViewController;
            gdvvc.postId = postIdForSegue;
        }
    }
}

- (IBAction)prepareForSearchUnit:(id)sender {
    
}


#pragma mark - GDManagerDelegate

- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo {
    NSLog(@"didReceiveHomeInfo");
    
    self.homeInfo = homeInfo;
    
    [self prepareCarousel];
    
    [self.view bringSubviewToFront:self.carouselLabel];
    
    self.carouselPageControl.numberOfPages = homeInfo.carousel.count;
    [self.view bringSubviewToFront:self.carouselPageControl];
    
//    self.view.hidden = NO;
   
    [self updatePageControlAccordingly];
    
    [self prepareVideoList];
    
    self.rootScrollView.contentSize = CGSizeMake(320,
                                                 self.videoListCollectionView.bounds.size.height + self.infiniteScrollView.bounds.size.height + 60);
    [self.rootScrollView layoutSubviews];
    
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
//    NSLog(@"Next page");
    [self updatePageControlAccordingly];
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView
{
//    NSLog(@"Previous page");
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
//    NSLog(@"infiniteScrollView:pageAtIndex:%lu", (unsigned long)index);
    
    if (!self.homeInfo) {
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, infiniteScrollView.bounds.size.width, infiniteScrollView.bounds.size.height);
    
    GBInfiniteScrollViewPage *page = [infiniteScrollView dequeueReusablePage];
    
    if (!page) {
        page = [[GBInfiniteScrollViewPage alloc] initWithFrame:frame
                                                         style:GBInfiniteScrollViewPageStyleText];
    }
    
    [page prepareForReuse];
    
//    page.textLabel.text = record.text;
//    page.textLabel.textColor = record.textColor;
//    page.contentView.backgroundColor = record.backgroundColor;
//    page.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:128.0f];
    
    CarouselInfo *ci = (CarouselInfo*)[self.homeInfo.carousel objectAtIndex:index];
  
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImageWithURL:[NSURL URLWithString:ci.imageURL]];
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carouselTapped:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = YES;
    
    [page addGestureRecognizer:tap];

    [page.contentView addSubview:imageView];
    
    page.tag = index;
    
    return page;
}

- (void) carouselTapped:(UITapGestureRecognizer *)gesture {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Carousel Item Clicked!"
//                                                    message: [NSString stringWithFormat:@"You clcked on %d!", gesture.view.tag]
//                                                   delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
    CarouselInfo *vli = [self.homeInfo.carousel objectAtIndex: gesture.view.tag];
    if (vli.gdPostType == 1) {
        postIdForSegue = vli.postId;
        [self performSegueWithIdentifier:@"ViewPost" sender:self];
    } else if (vli.gdPostType == 2) {
        postIdForSegue = vli.postId;
        [self performSegueWithIdentifier:@"ViewVideo" sender:self];
    }
}

- (void) updatePageControlAccordingly {
    int pageIndex = self.infiniteScrollView.currentPageIndex;
    
    CarouselInfo *ci = (CarouselInfo*)[self.homeInfo.carousel objectAtIndex:pageIndex];
    
    // update the label
    self.carouselLabel.text = ci.title;
    self.carouselPageControl.currentPage = pageIndex;
    
//    NSLog(@"updatePageControlAccordingly %d %@", pageIndex, ci.title);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.homeInfo.videoList.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"indexPath.row: %d", indexPath.row);
    
    VideoListItem *vli = (VideoListItem*)[self.homeInfo.videoList objectAtIndex:indexPath.row];
//    NSLog(@"should: %@, %@", vli.title, vli.title2);
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoListCell" forIndexPath:indexPath];
    [cell prepareForReuse];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 84)];
    [imageView setImageWithURL:[NSURL URLWithString:vli.imageURL]];
    imageView.tag = indexPath.row;
    
    [cell addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 150, 21)];
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [label setFont:[UIFont systemFontOfSize:12]];
    label.text = vli.title;
    label.tag = 10 + indexPath.row;
    [cell addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 67, 150, 17)];
    label2.textAlignment = NSTextAlignmentRight;
    label2.backgroundColor = [UIColor blackColor];
    label2.textColor = [UIColor whiteColor];
    label2.opaque = false;
    label2.alpha = 0.7;
    [label2 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [label2 setFont:[UIFont systemFontOfSize:12]];
    label2.text = vli.title2;
    label2.tag = 30 + indexPath.row;
    [cell addSubview:label2];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoListTapped:)];
//    tap.numberOfTapsRequired = 1;
//    tap.cancelsTouchesInView = YES;
//    imageView.userInteractionEnabled = YES;
//    [imageView addGestureRecognizer:tap];
    
    GDPostCategoryView *postCategory = [[GDPostCategoryView alloc] initWithFrame:CGRectMake(0, 106, 30, 15) fontSize:10];
    postCategory.gdPostCategory = vli.gdPostCategory;
    [cell addSubview:postCategory];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 105, 110, 17)];
    [dateLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [dateLabel setFont:[UIFont systemFontOfSize:11]];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.text = [Utility dateStringByDay:vli.created];
    [cell addSubview:dateLabel];
    
    [cell setNeedsLayout];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    GDVideoViewController *gdpvc = [[GDVideoViewController alloc] init];
//    gdpvc.postId = 12345;
//
    VideoListItem *vli = [self.homeInfo.videoList objectAtIndex: indexPath.row];
    postIdForSegue = vli.postId;
    
    [self performSegueWithIdentifier:@"ViewVideo" sender:self];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Video List Item Clicked!"
//                                                    message: [NSString stringWithFormat:@"You clcked on %d!", indexPath.row]
//                                                   delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 135);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
