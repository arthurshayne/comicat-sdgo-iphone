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

#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "NSDate+PrettyDate.h"
#import "UIScrollView+GDPullToRefresh.h"
#import "SVPullToRefresh.h"
#import "UMSocial.h"
#import <JTSImageViewController.h>

#import "CarouselInfo.h"
#import "VideoListItem.h"
#import "HomeInfo.h"
#import "UnitInfoShort.h"

#import "GDVideoViewController.h"
#import "GDPostViewController.h"
#import "UnitViewController.h"

#import "GDEasterEgg.h"

#import "GDVideoListCollectionViewCell.h"
#import "GDPostListCollectionViewCell.h"
#import "GDUnitCollectionViewCell.h"
#import "GDPostCategoryView.h"
#import "NetworkErrorView.h"
#import "GlowingLogoView.h"

@interface GDHome2ViewController ()

//@property (strong, nonatomic) NSArray *images;  // of UIImage
@property (strong, nonatomic) GDManager *manager;
@property (strong, nonatomic) HomeInfo *homeInfo;



@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) GlowingLogoView *logoView;

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

@property (weak, nonatomic) IBOutlet GBInfiniteScrollView *infiniteScrollView;
@property (weak, nonatomic) IBOutlet UILabel *carouselLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *carouselPageControl;

@property (weak, nonatomic) IBOutlet UICollectionView *videoListCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *postListCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *unitsCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *searchUnitButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) NSMutableArray *postListCellBorders;
@property (strong, nonatomic) NSMutableArray *unitListCellBorders;
@end

@implementation GDHome2ViewController

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    
    return _manager;
}

- (GlowingLogoView *)logoView {
    if (!_logoView) {
        _logoView = [[GlowingLogoView alloc] initWithFrame:CGRectMake(0, 0, 64, 35)];
        [self.navigationView addSubview:_logoView];
    }
    return _logoView;
}

const CGFloat POSTLIST_CELL_HEIGHT = 65;
const CGFloat UNIT_CELL_WIDTH = 90;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUIControls];
    
    [self.videoListCollectionView registerClass:[GDVideoListCollectionViewCell class] forCellWithReuseIdentifier:@"VideoListCell"];
    [self.postListCollectionView registerClass:[GDPostListCollectionViewCell class] forCellWithReuseIdentifier:@"PostListCell"];
    [self.unitsCollectionView registerClass:[GDUnitCollectionViewCell class] forCellWithReuseIdentifier:@"UnitListCell"];
    
    [self configurePullToRefresh];
    
    [self.manager fetchHomeInfo:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"首页"];
    [self.infiniteScrollView startAutoScroll];
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureEasterEgg];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"首页"];
    [self.infiniteScrollView stopAutoScroll];
}

- (void)configureUIControls {
    self.carouselLabel.textColor = [UIColor whiteColor];
    self.carouselLabel.backgroundColor = [UIColor blackColor];
    self.carouselLabel.opaque = false;
    self.carouselLabel.alpha = 0.7;
    [self.carouselLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.carouselLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self.searchUnitButton setTitleColor:[GDAppUtility appTintColor] forState:UIControlStateNormal];
    [self.searchUnitButton setTitleColor:[GDAppUtility appTintColorHighlighted] forState:UIControlStateHighlighted];
    [self.searchUnitButton setImage:[UIImage imageNamed:@"search-button-hl"] forState:UIControlStateHighlighted];
    
    [self.shareButton setImage:[UIImage imageNamed:@"share-button-hl"] forState:UIControlStateHighlighted];
}

- (void)configureEasterEgg {
    // EasterEgg
    
    if ([GDEasterEgg isEasterEggEnabled]) {
        self.logoView.glowing = YES;
        
    } else {
        self.logoView.glowing = NO;
    }
    
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTapped:)];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTappedTwice:)];
    tapTwice.numberOfTapsRequired = 2;
    
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    [self.logoView addGestureRecognizer:tapOnce];
    [self.logoView addGestureRecognizer:tapTwice];
}

- (void)logoTapped:(id)sender {
    // [GDEasterEgg turnOnEasterEgg];
    if ([GDEasterEgg isEasterEggEnabled]) {
        // Create image info
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = [UIImage imageNamed:@"better-launch"];
        imageInfo.referenceRect = self.logoView.frame;
        imageInfo.referenceView = self.view;
        
        // Setup view controller
        JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                               initWithImageInfo:imageInfo
                                               mode:JTSImageViewControllerMode_Image
                                               backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
        
        // Present the view controller.
        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    }
}

- (void)logoTappedTwice:(id)sender {
    if ([GDEasterEgg isEasterEggEnabled]) {
        UnitViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitViewController"];
        uvc.unitId = @"88888";
        
        [self.navigationController pushViewController:uvc animated:YES];

    }
}

- (void)prepareCarousel {
    self.infiniteScrollView.infiniteScrollViewDataSource = self;
    self.infiniteScrollView.infiniteScrollViewDelegate = self;
    
    [self.infiniteScrollView reloadData];
    [self.infiniteScrollView startAutoScroll];

    self.infiniteScrollView.pageIndex = 0;
}

- (void)prepareUnitList {
    self.unitsCollectionView.dataSource = self;
    self.unitsCollectionView.delegate = self;
    
    self.unitListCellBorders = [NSMutableArray arrayWithCapacity:self.homeInfo.units.count];
    for (UnitInfoShort *u in self.homeInfo.units) {
        GDCVCellBorder border = GDCVCellBorderNone;
        
        if (u == self.homeInfo.units.firstObject) {
            border = GDCVCellBorderRight;
        } else if (u == self.homeInfo.units.lastObject) {
            border = GDCVCellBorderLeft;
        } else {
            border = GDCVCellBorderLeft | GDCVCellBorderRight;
        }
        
        [self.unitListCellBorders addObject:[NSNumber numberWithUnsignedInteger:border]];
    }
    
    self.unitsCollectionView.contentSize = CGSizeMake(UNIT_CELL_WIDTH * self.homeInfo.units.count, UNIT_CELL_WIDTH);
    
    [self.unitsCollectionView reloadData];
}

- (void)preparePostList {
    self.postListCollectionView.dataSource = self;
    self.postListCollectionView.delegate = self;
    
    self.postListCellBorders = [NSMutableArray arrayWithCapacity:self.homeInfo.postList.count];
    float rows = 0;
    BOOL joiningHalf = NO;
    for (PostInfo *p in self.homeInfo.postList) {
        GDCVCellBorder border = GDCVCellBorderNone; // = GDCVCellBorderTop | GDCVCellBorderBottom | GDCVCellBorderLeft | GDCVCellBorderRight;
        
        if (p.listStyle == 1) {
            // full
            rows += 1;
            joiningHalf = NO;
        } else if (p.listStyle == 2) {
            // half
            rows += 0.5;
            if (joiningHalf) {
                border |= GDCVCellBorderLeft;
            }
            joiningHalf = !joiningHalf;
        }
        
        NSUInteger indexOfPI = [self.homeInfo.postList indexOfObject:p];
        
        if (p == self.homeInfo.postList.lastObject ||
            (indexOfPI == self.homeInfo.postList.count - 2 &&
             p.listStyle == 2 &&
             ((PostInfo *)(self.homeInfo.postList.lastObject)).listStyle != 1)) {
            // last, or last 2 but half
        } else {
            border |= GDCVCellBorderBottom;
        }
        
        [self.postListCellBorders addObject:[NSNumber numberWithUnsignedInteger:border]];
    }
    
    rows = roundf(rows);
    
    CGRect frame = self.postListCollectionView.frame;
    CGRect frameOfUnits = self.unitsCollectionView.frame;
    
    frame.size.height = POSTLIST_CELL_HEIGHT * rows;
    frame.origin.y = frameOfUnits.origin.y + frameOfUnits.size.height + 6;
    [self.postListCollectionView setFrame: frame];
    self.postListCollectionView.contentSize = frame.size;
    
    [self.postListCollectionView reloadData];
}

- (void)prepareVideoList {
    self.videoListCollectionView.dataSource = self;
    self.videoListCollectionView.delegate = self;
    
    CGRect frame = self.videoListCollectionView.frame;
    CGRect frameOfPostList = self.postListCollectionView.frame;
    frame.size.height = 135 * self.homeInfo.videoList.count / 2;
    frame.origin.y = frameOfPostList.origin.y + frameOfPostList.size.height + 6;
    [self.videoListCollectionView setFrame: frame];
    self.videoListCollectionView.contentSize = frame.size;
    
    [self.videoListCollectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewVideo"]) {
        if ([segue.destinationViewController isKindOfClass:[GDVideoViewController class]]) {
            GDVideoViewController *gdpvc = (GDVideoViewController *)segue.destinationViewController;
            gdpvc.postId = postIdForSegue;
            gdpvc.hidesBottomBarWhenPushed = YES;
        }
    } else if([segue.identifier isEqualToString:@"ViewPost"]) {
        if ([segue.destinationViewController isKindOfClass:[GDPostViewController class]]) {
            GDVideoViewController *gdvvc = (GDVideoViewController *)segue.destinationViewController;
            gdvvc.postId = postIdForSegue;
        }
    } else if([segue.identifier isEqualToString:@"ViewUnit"]) {
        if ([segue.destinationViewController isKindOfClass:[UnitViewController class]]) {
            UnitViewController *uvc = (UnitViewController *)segue.destinationViewController;
            uvc.unitId = unitIdForSegue;
        }
    }
}

- (IBAction)prepareForSearchUnit:(id)sender {
    [self performSegueWithIdentifier:@"search-unit" sender:self];
}

- (IBAction)shareButtonPressed:(id)sender {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.title = @"漫猫SD敢达iPhone";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.sdgundam.cn/pages/app/iphone-landing-page.aspx";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"全宇宙首款SD敢达资料App, 一如既往的提供SD敢达最新情报, 最新视频和全机体资料!"
                                     shareImage:[UIImage imageNamed:@"AppIcon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToSms, UMShareToWechatTimeline, UMShareToWechatSession, nil]
                                       delegate:nil];
}

- (void)configurePullToRefresh {
    [self.rootScrollView addGDPullToRefreshWithActionHandler:^{
        BOOL shouldForce = lastPullToRefresh && fabs([lastPullToRefresh timeIntervalSinceNow]) < 10;
        [self.manager fetchHomeInfo:shouldForce];
        if (shouldForce) {
            lastPullToRefresh = nil;
        } else {
            lastPullToRefresh = [NSDate date];
        }
    }];
}

#pragma mark - GDManagerDelegate

- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo {
    [NetworkErrorView hideNEVForView:self.view];
    
    self.homeInfo = homeInfo;
    
    [self prepareCarousel];
    
    [self.view bringSubviewToFront:self.carouselLabel];
    
    self.carouselPageControl.numberOfPages = homeInfo.carousel.count;
    [self.view bringSubviewToFront:self.carouselPageControl];
   
    [self updatePageControlAccordingly];
    
    [self prepareUnitList];
    [self preparePostList];
    [self prepareVideoList];
    
    self.rootScrollView.contentSize = CGSizeMake(320,
                                                 self.postListCollectionView.bounds.size.height +
                                                 self.videoListCollectionView.bounds.size.height +
                                                 self.unitsCollectionView.bounds.size.height +
                                                 self.infiniteScrollView.bounds.size.height + 90 /* bottom padding*/);
    
    [self.rootScrollView layoutSubviews];
    
    [self stopAllLoadingAnimations];
}

- (void)fetchingHomeInfoWithError:(NSError *)error {
    [self stopAllLoadingAnimations];
    
    if ([GDAppUtility isViewDisplayed:self.view]) {
        [GDAppUtility alertError:error alertTitle:@"数据加载失败"];
    }
    
    if (!self.homeInfo) {
        // NSLog(@"NO homeinfo");
        // display network error view
        __weak typeof(self) weakSelf = self;
        [NetworkErrorView showNEVAddTo:self.view reloadCallback:^{
            [weakSelf.manager fetchHomeInfo:NO];
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:NO];
        }];
    }
}

- (void)stopAllLoadingAnimations {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.rootScrollView.pullToRefreshView stopAnimating];
    });
}

#pragma mark - GBInfiniteScroll

- (void)infiniteScrollViewDidScrollNextPage:(GBInfiniteScrollView *)infiniteScrollView {
//    NSLog(@"Next page");
    [self updatePageControlAccordingly];
}

- (void)infiniteScrollViewDidScrollPreviousPage:(GBInfiniteScrollView *)infiniteScrollView {
//    NSLog(@"Previous page");
    [self updatePageControlAccordingly];
}

- (NSInteger)numberOfPagesInInfiniteScrollView:(GBInfiniteScrollView *)infiniteScrollView {
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
    [imageView sd_setImageWithURL:[NSURL URLWithString:ci.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder-carousel"]];
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
    NSUInteger pageIndex = self.infiniteScrollView.currentPageIndex;
    
    CarouselInfo *ci = (CarouselInfo*)[self.homeInfo.carousel objectAtIndex:pageIndex];
    
    // update the label
    self.carouselLabel.text = ci.title;
    self.carouselPageControl.currentPage = pageIndex;
    
//    NSLog(@"updatePageControlAccordingly %d %@", pageIndex, ci.title);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view == self.videoListCollectionView) {
        return self.homeInfo.videoList.count;
    } else if (view == self.postListCollectionView) {
        return self.homeInfo.postList.count;
    } else if (view == self.unitsCollectionView) {
        return self.homeInfo.units.count;
    }
    
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cv == self.videoListCollectionView) {
        VideoListItem *vli = (VideoListItem*)[self.homeInfo.videoList objectAtIndex:indexPath.row];
        
        GDVideoListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoListCell" forIndexPath:indexPath];
        [cell prepareForReuse];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.videoListItem = vli;

        return cell;
    } else if (cv == self.postListCollectionView) {
        PostInfo *pi = (PostInfo*)[self.homeInfo.postList objectAtIndex:indexPath.row];
        
        GDPostListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PostListCell" forIndexPath:indexPath];
        [cell prepareForReuse];
        
        cell.border = (GDCVCellBorder)[((NSNumber *)[self.postListCellBorders objectAtIndex:indexPath.row]) unsignedIntegerValue];
        
        cell.backgroundColor = [UIColor whiteColor];
        [cell configureForPostInfo:pi];
        
        return cell;
    } else if (cv == self.unitsCollectionView) {
        UnitInfoShort *uis = (UnitInfoShort*)[self.homeInfo.units objectAtIndex:indexPath.row];
        
        GDUnitCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"UnitListCell" forIndexPath:indexPath];
        [cell prepareForReuse];
        
        cell.border = (GDCVCellBorder)[((NSNumber *)[self.unitListCellBorders objectAtIndex:indexPath.row]) unsignedIntegerValue];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.unitId = uis.unitId;
        
        return cell;
    }
    
//    NSLog(@"indexPath.row: %d", indexPath.row);
//    NSLog(@"should: %@, %@", vli.title, vli.title2);
    // [cell setNeedsLayout];
    
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (view == self.videoListCollectionView) {
        VideoListItem *vli = [self.homeInfo.videoList objectAtIndex: indexPath.row];
        postIdForSegue = vli.postId;
        
        [self performSegueWithIdentifier:@"ViewVideo" sender:self];
    } else if (view == self.postListCollectionView) {
        PostInfo *pi = [self.homeInfo.postList objectAtIndex: indexPath.row];
        postIdForSegue = pi.postId;
        
        [self performSegueWithIdentifier:@"ViewPost" sender:self];
    } else  if (view == self.unitsCollectionView) {
        UnitInfoShort *uis = [self.homeInfo.units objectAtIndex: indexPath.row];
        unitIdForSegue = uis.unitId;
        
        [self performSegueWithIdentifier:@"ViewUnit" sender:self];
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    // TODO: Deselect item
//}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)view layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (view == self.videoListCollectionView) {
        return CGSizeMake(150, 135);
    } else if (view == self.postListCollectionView) {
        PostInfo *pi = [self.homeInfo.postList objectAtIndex: indexPath.row];
        if (pi.listStyle == 1) {
            // Full
            return CGSizeMake(314, POSTLIST_CELL_HEIGHT);
        } else if (pi.listStyle == 2) {
            // Half
            return CGSizeMake(157, POSTLIST_CELL_HEIGHT);
        }
    } else if (view == self.unitsCollectionView) {
        return CGSizeMake(UNIT_CELL_WIDTH, UNIT_CELL_WIDTH);
    }
    
    return CGSizeZero;
}

//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

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
