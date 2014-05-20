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
#import "Utility.h"

#import "AAPullToRefresh.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"

#import "GDCategoryListView.h"
#import "GDVideoListCollectionViewCell.h"

#import "GDVideoViewController.h"

@interface GDVideoListViewController ()
@property (strong, nonatomic) NSMutableDictionary *videoListViews; // key: category value: UICollectionView
@property (retain, nonatomic) UICollectionView *currentVideoListView;

@property (strong, nonatomic) GDCategoryListView *categoryListView;

@property (strong, nonatomic) NSArray *gdCategories;

@property (strong, nonatomic) GDManager *manager;

@property NSUInteger currentGDCategory;
@property (strong, nonatomic, readonly) NSString *currentGDCategoryAsString;
// @property NSUInteger pageIndex;
@property (strong, nonatomic) NSMutableDictionary *pageIndexes;
@property (readonly) int pageIndexOfCurrengGDCategory;
// @property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSMutableDictionary *postsByGDCategory;
@property (strong, nonatomic, readonly) NSArray *postsOfCurrentGDCategory;
@property int selectedPostId;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) AAPullToRefresh *pullToRefresh;
@end

@implementation GDVideoListViewController

static int POST_LIST_PAGE_SIZE = 20;
static NSString *CELL_IDENTIFIER = @"VideoListTableCell%d";

int postIdForSegue;

#pragma mark - property getters
- (NSArray *)gdCategories {
    if (!_gdCategories ) {
        _gdCategories = [NSArray arrayWithObjects:@32, @16, @64, @256, @128, @512, @1024, @2048, nil];
    }
    return _gdCategories;
}

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory getGDManagerWithDelegate:self];
    }
    
    return _manager;
}

- (NSString *)currentGDCategoryAsString {
    return [NSString stringWithFormat:@"%d", self.currentGDCategory];
}

- (NSArray *)postsOfCurrentGDCategory {
    return (NSArray *)[self.postsByGDCategory objectForKey:self.currentGDCategoryAsString];
}

- (int)pageIndexOfCurrengGDCategory {
    return [((NSNumber *)[self.pageIndexes objectForKey:self.currentGDCategoryAsString]) intValue];
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

- (NSMutableDictionary *)postsByGDCategory {
    if (!_postsByGDCategory) {
        _postsByGDCategory = [[NSMutableDictionary alloc] init];
    }
    return _postsByGDCategory;
}

- (NSMutableDictionary *)pageIndexes {
    if (!_pageIndexes) {
        _pageIndexes = [[NSMutableDictionary alloc] init];
    }
    return _pageIndexes;
}

#pragma mark - ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    

    [self prepareCategoryList];
    
    self.currentGDCategory = 0;
    // [self loadDataOfCurrentGDCategory:YES];
    
    [self configureVideoListViewForGDCategory:self.currentGDCategory];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)didReceiveMemoryWarning {
    
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

#pragma mark - GDManagerDelegate
- (void)didReceiveVideoList:(NSArray *)posts ofGdCategory:(int)category {
    BOOL justReloaded = (self.postsOfCurrentGDCategory == nil || self.postsOfCurrentGDCategory.count == 0);
    
    if (posts.count < POST_LIST_PAGE_SIZE || posts.count == 0) {
        // TODO: its over...
        
    }
    
    if (posts.count > 0) {
        [self appendPosts:posts intoGDCategory:category];
    }
    
    if (self.currentGDCategory == category) {
        if (justReloaded) {
            [self.currentVideoListView reloadData];
            [self stopAllLoadingAnimations];
        } else {
            [self.currentVideoListView performBatchUpdates:^{
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                for (int i = self.postsOfCurrentGDCategory.count - posts.count; i < self.postsOfCurrentGDCategory.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
                [self.currentVideoListView insertItemsAtIndexPaths:indexPaths];

            } completion:^(BOOL finished) {
                if (justReloaded) {
                    [self.currentVideoListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                                      atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                }
               
                [self stopAllLoadingAnimations];
            }];
        }
    }
}

- (void)stopAllLoadingAnimations {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self.currentVideoListView.infiniteScrollingView stopAnimating];
    [self.pullToRefresh stopIndicatorAnimation];
}

- (void)appendPosts:(NSArray *)posts intoGDCategory:(NSInteger)category {
    NSMutableArray *newPosts = [NSMutableArray arrayWithArray:((NSArray *)[self.postsByGDCategory objectForKey:[self stringWithGDCategory:category]])];
    [newPosts addObjectsFromArray:posts];
    [self.postsByGDCategory setObject:[NSArray arrayWithArray:newPosts] forKey:[self stringWithGDCategory:category]];
}

- (void)fetchVideoListWithError:(NSError *)error {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)[self.postsByGDCategory objectForKey:self.currentGDCategoryAsString]).count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"indexPath.row: %d", indexPath.row);
    
    GDVideoListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    VideoListItem *vli = (VideoListItem*)[self.postsOfCurrentGDCategory objectAtIndex:indexPath.row];
    //    NSLog(@"should: %@, %@", vli.title, vli.title2);
    
    if (vli) {
        [cell prepareForReuse];
        
        cell.backgroundColor = [UIColor whiteColor];
        [cell configureForVideoListItem:vli];
        
        [cell setNeedsLayout];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoListItem *vli = [self.postsOfCurrentGDCategory objectAtIndex: indexPath.row];
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

- (void)tappedOnCategoryViewWithCategory:(int)category {
    if (self.currentGDCategory != category) {
        // should clear the array
        self.currentGDCategory = category;
        
        // [self loadDataOfCurrentGDCategory:YES];
        [self configureVideoListViewForGDCategory:category];
    }
}

- (void)tappedOnShowAll {
    if (self.currentGDCategory != 0) {
        self.currentGDCategory = 0;
        
        [self configureVideoListViewForGDCategory:0];
        // [self loadDataOfCurrentGDCategory:YES];
    }
}


#pragma mark - Multiple UICollectionView

- (void)configureVideoListViewForGDCategory:(NSUInteger)gdCategory {
    self.currentVideoListView.hidden = YES;
    
    UICollectionView *videoListViewThis = [self.videoListViews objectForKey:@(gdCategory)];
    if (videoListViewThis) {
        videoListViewThis.hidden = NO;
        self.currentVideoListView = videoListViewThis;
    } else {
        videoListViewThis = [self createVideoListViewForGDCategory:gdCategory];
        self.currentVideoListView = videoListViewThis;
        
        [videoListViewThis registerClass:[GDVideoListCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        // self.videoListView.infiniteScrollingView.enabled = YES;
        
        [self configurePullToRefresh];
        [self configureScrollToViewMore];
        
        // load init data
        [self loadDataOfGDCategory:gdCategory shouldReload:YES];
    }
}

- (UICollectionView *)createVideoListViewForGDCategory:(NSUInteger)gdCategory {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    
    UICollectionView *videoListView = [[UICollectionView alloc] initWithFrame:CGRectMake(6, 114, 308, 405) collectionViewLayout:flow];
    videoListView.backgroundColor = [UIColor clearColor];
    videoListView.opaque = YES;
    
    [self.view addSubview:videoListView];
    
    
    videoListView.dataSource = self;
    videoListView.delegate = self;
    
    return videoListView;
}

- (void)loadDataOfGDCategory:(NSUInteger)gdCategory shouldReload:(BOOL)reload {
    if (reload) {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        [self.pageIndexes setObject:@0 forKey:[self stringWithGDCategory:gdCategory]];
        [self.postsByGDCategory setObject:[[NSArray alloc] init] forKey:[self stringWithGDCategory:gdCategory]];
    }
    
    [self.manager fetchVideoListOfCategory:gdCategory pageSize:POST_LIST_PAGE_SIZE pageIndex:self.pageIndexOfCurrengGDCategory];
}

- (void)loadDataOfCurrentGDCategory:(BOOL)reload {
    [self loadDataOfGDCategory:self.currentGDCategory shouldReload:reload];
}

- (void)configurePullToRefresh {
    __weak typeof(self) weakSelf = self;
    self.pullToRefresh = [self.currentVideoListView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        [weakSelf loadDataOfCurrentGDCategory:YES];
    }];
    // don't display at once
    [self.pullToRefresh stopIndicatorAnimation];
    self.pullToRefresh.imageIcon = [UIImage imageNamed:@"halo"];
    self.pullToRefresh.threshold = 80.0f;
    self.pullToRefresh.borderWidth = 3;
}

- (void)configureScrollToViewMore {
    __weak typeof(self) weakSelf = self;
    [self.currentVideoListView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.pageIndexes setObject:@(weakSelf.pageIndexOfCurrengGDCategory + 1) forKey:weakSelf.currentGDCategoryAsString];
        [weakSelf loadDataOfCurrentGDCategory:NO];
    }];
}

#pragma mark - Misc

- (NSString *)stringWithGDCategory:(NSUInteger)gdCategory {
    return [NSString stringWithFormat:@"%d", gdCategory];
}

@end
