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
@property (weak, nonatomic) IBOutlet UICollectionView *videoListView;

@property (strong, nonatomic) GDCategoryListView *categoryListView;

@property (strong, nonatomic) NSArray *gdCategories;

@property (strong, nonatomic) GDManager *manager;

@property NSUInteger currentGDCategory;
@property NSUInteger pageIndex;
@property (strong, nonatomic) NSArray *posts;
@property int selectedPostId;

@property (weak, nonatomic) AAPullToRefresh *pullToRefresh;
@end

@implementation GDVideoListViewController

static int POST_LIST_PAGE_SIZE = 20;
static NSString *CELL_IDENTIFIER = @"VideoListTableCell";

int postIdForSegue;

- (NSArray *)gdCategories {
    if (!_gdCategories ) {
        _gdCategories = [NSArray arrayWithObjects:@32, @16, @64, @256, @128, @512, @1024, @2048, nil];
    }
    return _gdCategories;
}

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory getGDManagerWithDelegate:self];
    }
    
    return _manager;
}

NSDateFormatter *nsdf;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    nsdf = [[NSDateFormatter alloc] init];
    nsdf.dateFormat = @"yyyy-MM-dd";
    
    [self prepareCategoryList];
    
    self.currentGDCategory = 0;
    [self loadDataOfcurrentGDCategory:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configurePullToRefresh];
    [self configureScrollToViewMore];
    
    [self.videoListView registerClass:[GDVideoListCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    //[self loadDataOfcurrentGDCategory:YES];
    
    self.videoListView.dataSource = self;
    self.videoListView.delegate = self;
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

- (void)configurePullToRefresh {
    self.pullToRefresh = [self.videoListView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        [self loadDataOfcurrentGDCategory:YES];
    }];
    // don't display at once
    [self.pullToRefresh stopIndicatorAnimation];
    self.pullToRefresh.imageIcon = [UIImage imageNamed:@"halo"];
    self.pullToRefresh.threshold = 60.0f;
    self.pullToRefresh.borderWidth = 3;
}

- (void)configureScrollToViewMore {
    [self.videoListView addInfiniteScrollingWithActionHandler:^{
        self.pageIndex++;
        [self loadDataOfcurrentGDCategory:NO];
    }];
}

- (void)prepareCategoryList {
    self.categoryListView = [[GDCategoryListView alloc] initWithFrame:CGRectMake(0, 66, 320, 35)];
    self.categoryListView.delegate = self;
    self.categoryListView.gdCategoryList = self.gdCategories;
    [self.view addSubview:self.categoryListView];
}

- (void)loadDataOfcurrentGDCategory:(BOOL)shouldReload {
    if (shouldReload) {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        self.videoListView.infiniteScrollingView.enabled = YES;
        
        self.pageIndex = 0;
        self.posts = nil;
        
        [self.videoListView reloadData];
    }
    
    [self.manager fetchVideoListOfCategory:self.currentGDCategory pageSize:POST_LIST_PAGE_SIZE pageIndex:self.pageIndex];
}

#pragma mark - GDManagerDelegate
- (void)didReceiveVideoList:(NSArray *)posts ofGdCategory:(int)category {
    BOOL justReloaded = (self.posts == nil);
    
    if (posts.count < POST_LIST_PAGE_SIZE || posts.count == 0) {
        // TODO: its over...
        
    }
    
    if (self.currentGDCategory == category) {
        if (!self.posts) {
            self.posts = [[NSArray alloc] init];
        }
        [self appendPosts:posts];
        
        
        [self.videoListView performBatchUpdates:^{
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (int i = self.posts.count - posts.count; i < self.posts.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [self.videoListView insertItemsAtIndexPaths:indexPaths];

        } completion:^(BOOL finished) {
            CGRect frame = self.videoListView.frame;
            frame.size.height = 135 * self.posts.count / 2;
            self.videoListView.contentSize = frame.size;

            if (justReloaded) {
                [self.videoListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        }];
    }
    
    //
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self.videoListView.infiniteScrollingView stopAnimating];
    [self.pullToRefresh stopIndicatorAnimation];

}

- (void)appendPosts:(NSArray *)posts {
    NSMutableArray *newPosts = [NSMutableArray arrayWithArray:self.posts];
    [newPosts addObjectsFromArray:posts];
    self.posts = [NSArray arrayWithArray:newPosts];
}

- (void)fetchVideoListWithError:(NSError *)error {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"indexPath.row: %d", indexPath.row);
    
    GDVideoListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    VideoListItem *vli = (VideoListItem*)[self.posts objectAtIndex:indexPath.row];
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
    VideoListItem *vli = [self.posts objectAtIndex: indexPath.row];
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
        
        [self loadDataOfcurrentGDCategory:YES];
    }
}

- (void)tappedOnShowAll {
    if (self.currentGDCategory != 0) {
        self.currentGDCategory = 0;
        [self loadDataOfcurrentGDCategory:YES];
    }
}

@end
