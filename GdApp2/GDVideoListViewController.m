//
//  GDVideoListViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDVideoListViewController.h"

#import "GDManager.h"
#import "GDManagerFactory.h"
#import "GDVideoListVCDataSource.h"

#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+GDPullToRefresh.h"

#import "GDCategoryListView.h"
#import "GDVideoListCollectionViewCell.h"
#import "SVPTRView.h"
#import "SVPTRLoadingView.h"
#import "NetworkErrorView.h"

#import "GDVideoViewController.h"


@interface GDVideoListViewController ()
@property (strong, nonatomic) NSMutableDictionary *videoListViews; // key: category value: UICollectionView
@property (retain, nonatomic, readonly) UICollectionView *currentVideoListView;
@property (strong, nonatomic) NSMutableDictionary *dataSources;    // key: category value: GDVLVCDataSource

@property (strong, nonatomic) GDCategoryListView *categoryListView;

@property (strong, nonatomic) NSArray *gdCategories;

@property (strong, nonatomic) GDManager *manager;

@property uint currentGDCategory;
@property (strong, nonatomic, readonly) NSString *currentGDCategoryAsString;

@property int selectedPostId;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

// @property (weak, nonatomic) AAPullToRefresh *pullToRefresh;
@end

@implementation GDVideoListViewController

static const NSString *CELL_IDENTIFIER = @"VideoListTableCell";

int postIdForSegue;

#pragma mark - property getters
- (NSArray *)gdCategories {
    if (!_gdCategories ) {
        _gdCategories = [NSArray arrayWithObjects:@32, @16, @64, @256, @128, @512, @1024, @2048, nil];
    }
    return _gdCategories;
}

- (NSString *)currentGDCategoryAsString {
    return [NSString stringWithFormat:@"%lu", (unsigned long)self.currentGDCategory];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSMutableDictionary *)videoListViews {
    if (!_videoListViews) {
        _videoListViews = [[NSMutableDictionary alloc] init];
    }
    return _videoListViews;
}

- (UICollectionView *)currentVideoListView {
    return [self.videoListViews objectForKey:self.currentGDCategoryAsString];
}

- (NSMutableDictionary *)dataSources {
    if (!_dataSources) {
        _dataSources = [[NSMutableDictionary alloc] initWithCapacity:self.gdCategories.count];
        for (NSUInteger i = 0; i < self.gdCategories.count; i++) {
            uint gdCategory = [((NSNumber *)[self.gdCategories objectAtIndex:i]) unsignedIntValue];
            GDVideoListVCDataSource *ds = [[GDVideoListVCDataSource alloc] initWithGDCategory:gdCategory];
            ds.delegate = self;
            [_dataSources setObject:ds forKey:[self stringWithGDCategory:gdCategory]];
        }
        
        GDVideoListVCDataSource *ds = [[GDVideoListVCDataSource alloc] initWithGDCategory:0];
        ds.delegate = self;
        [_dataSources setObject:ds forKey:@"0"];
        
    }
    return _dataSources;
}

//- (NSMutableDictionary *)postsByGDCategory {
//    if (!_postsByGDCategory) {
//        _postsByGDCategory = [[NSMutableDictionary alloc] init];
//    }
//    return _postsByGDCategory;
//}
//
//- (NSMutableDictionary *)pageIndexes {
//    if (!_pageIndexes) {
//        _pageIndexes = [[NSMutableDictionary alloc] init];
//    }
//    return _pageIndexes;
//}

#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self switchGDCategory:0];
    
    [self prepareCategoryList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"视频列表"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"视频列表"];
}

- (void)didReceiveMemoryWarning {
//    self.postsByGDCategory = nil;
    self.videoListViews = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewVideo"]) {
        if ([segue.destinationViewController isKindOfClass:[GDVideoViewController class]]) {
            GDVideoViewController *gdpvc = (GDVideoViewController *)segue.destinationViewController;
            gdpvc.postId = postIdForSegue;
            gdpvc.hidesBottomBarWhenPushed = YES;
        }
    }
}

- (void)prepareCategoryList {
    self.categoryListView = [[GDCategoryListView alloc] initWithFrame:CGRectMake(0, 66, 320, 35)];
    self.categoryListView.delegate = self;
    self.categoryListView.gdCategoryList = self.gdCategories;
    [self.view addSubview:self.categoryListView];
}

- (void)switchGDCategory:(uint)gdCategory {
    [self configureVideoListViewForGDCategory:gdCategory];
    self.currentGDCategory = gdCategory;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GDVideoListVCDataSource *dataSource = [self.dataSources objectForKey:self.currentGDCategoryAsString];
    VideoListItem *vli = [dataSource vliForIndexPath:indexPath];
    postIdForSegue = vli.postId;
    
    [self performSegueWithIdentifier:@"ViewVideo" sender:self];
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    // TODO: Deselect item
//}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 135);
}


#pragma mark - GDCategoryListViewDelegate

- (void)tappedOnCategoryViewWithCategory:(int)gdCategory {
    if (self.currentGDCategory != gdCategory) {
        // should clear the array
        // [self loadDataOfCurrentGDCategory:YES];
        [self switchGDCategory:gdCategory];
    }
}

- (void)tappedOnShowAll {
    if (self.currentGDCategory != 0) {
        [self switchGDCategory:0];
    }
}


#pragma mark - Multiple UICollectionView

- (void)configureVideoListViewForGDCategory:(uint)gdCategory {
    // self.currentVideoListView.hidden = YES;
    for (NSUInteger i = 0; i < self.videoListViews.allValues.count; i++) {
        ((UICollectionView *)[self.videoListViews.allValues objectAtIndex:i]).hidden = YES;
    }
    
    UICollectionView *videoListViewThis = [self.videoListViews objectForKey:[self stringWithGDCategory:gdCategory]];
    if (videoListViewThis) {
        videoListViewThis.hidden = NO;
    } else {
        videoListViewThis = [self createVideoListViewForGDCategory:gdCategory];
        
        [videoListViewThis registerClass:[GDVideoListCollectionViewCell class] forCellWithReuseIdentifier:[CELL_IDENTIFIER copy]];

        // self.videoListView.infiniteScrollingView.enabled = YES;
        
        [self configurePullToRefresh:gdCategory forView:videoListViewThis];
        [self configureScrollToViewMore:gdCategory forView:videoListViewThis];
        
        [self.videoListViews setObject:videoListViewThis forKey:[self stringWithGDCategory:gdCategory]];
        
        // load init data
        GDVideoListVCDataSource *dataSource = [self.dataSources objectForKey:[self stringWithGDCategory:gdCategory]];
        [dataSource reloadData];
    }
}

- (UICollectionView *)createVideoListViewForGDCategory:(NSUInteger)gdCategory {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    
    UICollectionView *videoListView = [[UICollectionView alloc] initWithFrame:CGRectMake(6, 114, 308, 454) collectionViewLayout:flow];
    videoListView.backgroundColor = [UIColor clearColor];
    videoListView.opaque = YES;
    videoListView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    [self.view addSubview:videoListView];
    
    GDVideoListVCDataSource *dataSource = [self.dataSources objectForKey:[self stringWithGDCategory:gdCategory]];
    
    videoListView.dataSource = dataSource;
    videoListView.delegate = self;
    
    return videoListView;
}

- (void)configurePullToRefresh:(uint)gdCategory forView:(UICollectionView *)collectionView {
    __weak typeof(self) weakSelf = self;

    [collectionView addGDPullToRefreshWithActionHandler:^{
        GDVideoListVCDataSource *ds = (GDVideoListVCDataSource *)[weakSelf.dataSources objectForKey:[weakSelf stringWithGDCategory:gdCategory]];
        [ds reloadData];

        UICollectionView *view = [self.videoListViews objectForKey:[self stringWithGDCategory:gdCategory]];
        view.showsInfiniteScrolling = YES;
    }];
}

- (void)configureScrollToViewMore:(uint)gdCategory forView:(UICollectionView *)collectionView {
    __weak typeof(self) weakSelf = self;
    [collectionView addInfiniteScrollingWithActionHandler:^{
        GDVideoListVCDataSource *ds = (GDVideoListVCDataSource *)[weakSelf.dataSources objectForKey:[weakSelf stringWithGDCategory:gdCategory]];
        [ds loadMore];
    }];
}

#pragma mark - Misc

- (NSString *)stringWithGDCategory:(NSUInteger)gdCategory {
    return [NSString stringWithFormat:@"%lu", (unsigned long)gdCategory];
}

- (void)stopAllLoadingAnimations {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self.currentVideoListView.infiniteScrollingView stopAnimating];
    [self.currentVideoListView.pullToRefreshView stopAnimating];
}

#pragma mark - GDVideoListDataSourceDelegate
- (void)dataDidPrepared:(NSUInteger)numberOfNewItems
        previouslyHave:(NSUInteger)numberOfOldItems
          ofGDCategory:(uint)gdCategory
          needToReload:(BOOL)reload {
    
    [NetworkErrorView hideNEVForView:self.view];
    
    UICollectionView *view = [self.videoListViews objectForKey:[self stringWithGDCategory:gdCategory]];
    
    if (reload) {
        [view reloadData];
        [self stopAllLoadingAnimations];
    } else {
        [UICollectionView setAnimationsEnabled:NO];   // disable animation for collection view
        [view performBatchUpdates:^{
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (NSUInteger i = numberOfOldItems; i < numberOfOldItems + numberOfNewItems; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [view insertItemsAtIndexPaths:indexPaths];
            
        } completion:^(BOOL finished) {
            [self stopAllLoadingAnimations];
            [GDVideoListCollectionViewCell setAnimationsEnabled:YES];
        }];
    }
}

- (void)dataSourceWithError:(NSError *)error {
    [self stopAllLoadingAnimations];
    
    if ([GDAppUtility isViewDisplayed:self.view]) {
        [GDAppUtility alertError:error alertTitle:@"数据加载失败"];
    }
    
    [NetworkErrorView showNEVAddTo:self.view reloadCallback:^{
        GDVideoListVCDataSource *ds = (GDVideoListVCDataSource *)[self.dataSources objectForKey:[self stringWithGDCategory:self.currentGDCategory]];
        [ds reloadData];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    }];
}

- (void)noMoreDataFromGDCategory:(unsigned int)gdCategory {
    UICollectionView *view = [self.videoListViews objectForKey:[self stringWithGDCategory:gdCategory]];
    // disable infinite scroll
    view.showsInfiniteScrolling = NO;
}

- (void)willLoadDataFromGDCategory:(unsigned int)gdCategory isReloading:(BOOL)reloading {
    if (reloading) {
        // UICollectionView *view = [self.videoListViews objectForKey:[self stringWithGDCategory:gdCategory]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

@end


/*TODO
 1. Open a thread calling data from back-end server, load data from all GD-Categories, when display to UI according to category, choose from the big list
 2.
 */
