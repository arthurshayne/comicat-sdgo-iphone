//
//  GDNewsListViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/11/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDNewsListViewController.h"

#import "GDManager.h"
#import "GDManagerFactory.h"
#import "Utility.h"

#import "AAPullToRefresh.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"

#import "GDPostListTableViewCell.h"
#import "GDCategoryListView.h"

#import "GDPostViewController.h"

@interface GDNewsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *postListTableView;

@property (strong, nonatomic) GDCategoryListView *categoryListView;

@property (strong, nonatomic) NSArray *gdCategories;

@property (strong, nonatomic) GDManager *manager;

@property NSUInteger currentGdCategory;
@property NSUInteger pageIndex;
@property (strong, nonatomic) NSArray *posts;
@property int selectedPostId;

// @property (strong, nonatomic) NSDictionary *postsByDate;    // NSString, NSArray

@property (weak, nonatomic) AAPullToRefresh *pullToRefresh;
// @property (weak, nonatomic) AAPullToRefresh *scrollToShowMore;

@end

@implementation GDNewsListViewController

static int POST_LIST_PAGE_SIZE = 20;

static NSString *CELL_IDENTIFIER = @"PostListTableCell";

- (NSArray *)gdCategories {
    if (!_gdCategories ) {
        _gdCategories = [NSArray arrayWithObjects:@1, @32, @16, @64, @256, @128, @512, @1024, @2048, nil];
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

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    nsdf = [[NSDateFormatter alloc] init];
    nsdf.dateFormat = @"yyyy-MM-dd";
    
    [self prepareCategoryList];
    
    self.currentGdCategory = 0;
    [self loadDataOfCurrentGDCategory:YES];
    
    [self.postListTableView registerClass:[GDPostListTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configurePullToRefresh];
    [self configureScrollToViewMore];
    
//    [self displayCategorySelectionIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    [self.postListTableView deselectRowAtIndexPath:self.postListTableView.indexPathForSelectedRow animated:NO];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"viewDidLayoutSubviews");
    [super viewDidLayoutSubviews];

    // prevent "selection" view being widen when back from segue
//    [self displayCategorySelectionIfNeeded];
}

- (void)configurePullToRefresh {
    self.pullToRefresh = [self.postListTableView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        [self loadDataOfCurrentGDCategory:YES];
    }];
    // don't display at once
    [self.pullToRefresh stopIndicatorAnimation];
    self.pullToRefresh.imageIcon = [UIImage imageNamed:@"halo"];
    self.pullToRefresh.threshold = 60.0f;
    self.pullToRefresh.borderWidth = 3;
}

- (void)configureScrollToViewMore {
    [self.postListTableView addInfiniteScrollingWithActionHandler:^{
        self.pageIndex++;
        [self loadDataOfCurrentGDCategory:NO];
    }];
}

- (void)prepareCategoryList {
    self.categoryListView = [[GDCategoryListView alloc] initWithFrame:CGRectMake(0, 66, 320, 35)];
    self.categoryListView.delegate = self;
    self.categoryListView.gdCategoryList = self.gdCategories;
    [self.view addSubview:self.categoryListView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if([segue.identifier isEqualToString:@"ViewPost"])  {
        if ([segue.destinationViewController isKindOfClass:[GDPostViewController class]]) {
            GDPostViewController *gdvvc = (GDPostViewController *)segue.destinationViewController;
            gdvvc.postId = self.selectedPostId;
        }
    }
}

- (void)loadDataOfCurrentGDCategory:(BOOL)shouldReload {
    if (shouldReload) {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        self.postListTableView.infiniteScrollingView.enabled = YES;
        self.postListTableView.tableFooterView = nil;
        
        self.pageIndex = 0;
        self.posts = nil;
    }
    
    [self.manager fetchPostListOfCategory:self.currentGdCategory pageSize:POST_LIST_PAGE_SIZE pageIndex:self.pageIndex];
    
//    [self displayCategorySelectionIfNeeded];
}

#pragma mark - GDManagerDelegate

- (void)didReceivePostList:(NSArray *)posts ofGdCategory:(int)category {
    NSLog(@"Category: %d", category);
    //NSLog(@"offset y:%f", self.postListTableView.contentOffset.y);
    //CGFloat scrollOffsetY = self.postListTableView.contentOffset.y;
    BOOL justReloaded = (self.posts == nil);
    
    if (posts.count < POST_LIST_PAGE_SIZE || posts.count == 0) {
        // its over...
        self.postListTableView.infiniteScrollingView.enabled = NO;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        UILabel *noMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 320, 24)];
        noMoreLabel.text = @"没有更多了...";
        noMoreLabel.textColor = [Utility UIColorFromRGB:0x666666];
        noMoreLabel.textAlignment = NSTextAlignmentCenter;
        
        [footerView addSubview:noMoreLabel];
        self.postListTableView.tableFooterView = footerView;
        [self.postListTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    }
    
    // didn't change since last change
    if (self.currentGdCategory == category) {
        if (!self.posts) {
            self.posts = posts;
        } else {
            [self appendPosts:posts];
        }
        
        if (justReloaded) {
            [self.postListTableView reloadData];
        } else {
            // load more
            [self.postListTableView beginUpdates];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (int i = self.posts.count - posts.count; i < self.posts.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [self.postListTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.postListTableView endUpdates];
            
            // set the offset to corrent
            //            NSLog(@"offset 2 y:%f", self.postListTableView.contentOffset.y);
            // self.postListTableView.contentOffset = CGPointMake(0, scrollOffsetY + 30);
            //            NSLog(@"offset 3 y:%f", self.postListTableView.contentOffset.y);
        }
        
        if (self.pageIndex == 0) {
            [self performSelector:@selector(scrollTableViewToTop:) withObject:self afterDelay:0.1];
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        }
    }
    
    
    [self.postListTableView.infiniteScrollingView stopAnimating];
    [self.pullToRefresh stopIndicatorAnimation];
}


- (void)scrollTableViewToTop:(id)nothing {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//    self.postListTableView.hidden = NO;
    //[self.postListTableView scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:NO];
    [self.postListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionNone
                                          animated:NO];
}

- (void)appendPosts:(NSArray *)posts {
    NSMutableArray *newPosts = [NSMutableArray arrayWithArray:self.posts];
    [newPosts addObjectsFromArray:posts];
    self.posts = [NSArray arrayWithArray:newPosts];
}

//- (void)mergePosts:(NSArray *)posts sections:(NSArray **)section indexPaths:(NSArray **)indexPaths {
//    NSMutableDictionary *postsByDateMutable = [NSMutableDictionary dictionaryWithDictionary:self.postsByDate];
//    for (PostInfo *p in posts) {
//        NSString *dateString = [nsdf stringFromDate:p.created];
//        NSArray *existingPosts = [postsByDateMutable objectForKey:dateString];
//        NSMutableArray *withNewPosts;
//        if (existingPosts == nil || existingPosts.count == 0) {
//            withNewPosts = [[NSMutableArray alloc] init];
//        } else {
//            withNewPosts = [NSMutableArray arrayWithArray:existingPosts];
//        }
//        
//        [postsByDateMutable setObject:[withNewPosts arrayByAddingObject:p] forKey:dateString];
//    }
//    
//    self.dateStrings = [postsByDateMutable.allKeys sortedArrayUsingComparator:^(id a, id b) {
//        return -[a compare:b options:NSNumericSearch];
//    }];
//    
//    self.postsByDate = [NSDictionary dictionaryWithDictionary:postsByDateMutable];
//}


- (void)fetchPostListWithError:(NSError *)error {
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.dateStrings objectAtIndex:section];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: build array for post count;
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *startDate = [NSDate date];
    
    //if (indexPath.section == 0) {
    GDPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    PostInfo *post = [self.posts objectAtIndex:indexPath.row];
    
    [cell configureForPostInfo:post];
    
    double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
    NSLog(@"cell: %f", timePassed_ms);
    
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *startDate = [NSDate date];

    PostInfo *post = [self.posts objectAtIndex:indexPath.row];
    
    double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
    NSLog(@"height: %f", timePassed_ms);
    
    return [GDPostListTableViewCell cellHeightForPostInfo:post];
}

//- (PostInfo *)findPostByIndexPath:(NSIndexPath *)indexPath {
//    NSString *dateString = [self.dateStrings objectAtIndex:indexPath.section];
//    NSArray *posts = [self.postsByDate objectForKey:dateString];
//    
//    return [posts objectAtIndex:indexPath.row];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostInfo *post = [self.posts objectAtIndex:indexPath.row];
    self.selectedPostId = post.postId;
    
    [self performSegueWithIdentifier:@"ViewPost" sender:self];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 135);
}

#pragma mark - GDCategoryListViewDelegate 

- (void)tappedOnCategoryViewWithCategory:(int)category {
    if (self.currentGdCategory != category) {
        // should clear the array
        self.currentGdCategory = category;
        
        [self loadDataOfCurrentGDCategory:YES];
    }
}

- (void)tappedOnShowAll {
    if (self.currentGdCategory != 0) {
        self.currentGdCategory = 0;
        [self loadDataOfCurrentGDCategory:YES];
    }
}

@end