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

#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+GDPullToRefresh.h"

#import "GDPostListTableViewCell.h"
#import "GDCategoryListView.h"

#import "GDPostViewController.h"

@interface GDNewsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *postListTableView;
@property (strong, nonatomic) GDCategoryListView *categoryListView;

@property (strong, nonatomic) NSArray *gdCategories;

@property (strong, nonatomic) GDManager *manager;

@property int currentGDCategory;
@property int pageIndex;
@property (strong, nonatomic) NSArray *posts;
@property int selectedPostId;

@property (strong, nonatomic) NSCache *cellHeightCache;

// @property (strong, nonatomic) NSDictionary *postsByDate;    // NSString, NSArray

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

- (NSCache *)cellHeightCache {
    if (!_cellHeightCache) {
        _cellHeightCache = [[NSCache alloc] init];
        [_cellHeightCache setCountLimit:200];
    }
    return _cellHeightCache;
}

NSDateFormatter *nsdf;

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    nsdf = [[NSDateFormatter alloc] init];
    nsdf.dateFormat = @"yyyy-MM-dd";
    
    [self prepareCategoryList];
    
    [self.postListTableView registerClass:[GDPostListTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    
    [self configurePullToRefresh];
    [self configureScrollToViewMore];
    
    self.currentGDCategory = 0;
    [self loadDataOfcurrentGDCategory:YES];

    
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
    [self.postListTableView addGDPullToRefreshWithActionHandler:^{
        [self loadDataOfcurrentGDCategory:YES];
    }];
}

- (void)configureScrollToViewMore {
    [self.postListTableView addInfiniteScrollingWithActionHandler:^{
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if([segue.identifier isEqualToString:@"ViewPost"])  {
        if ([segue.destinationViewController isKindOfClass:[GDPostViewController class]]) {
            GDPostViewController *gdvvc = (GDPostViewController *)segue.destinationViewController;
            gdvvc.postId = self.selectedPostId;
        }
    }
}

- (void)loadDataOfcurrentGDCategory:(BOOL)shouldReload {
    if (shouldReload) {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        self.postListTableView.infiniteScrollingView.enabled = YES;
        self.postListTableView.tableFooterView = nil;
        
        self.pageIndex = 0;
        self.posts = nil;
    }
    
    [self.manager fetchPostListOfCategory:self.currentGDCategory pageSize:POST_LIST_PAGE_SIZE pageIndex:self.pageIndex];
    
//    [self displayCategorySelectionIfNeeded];
}

#pragma mark - GDManagerDelegate

- (void)didReceivePostList:(NSArray *)posts ofGdCategory:(uint)category {
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
    if (self.currentGDCategory == category) {
        if (justReloaded) {
            [self.postListTableView reloadData];
            self.posts = posts;
            [self.postListTableView reloadData];
        } else {
            [self appendPosts:posts];
        
            // load more
            [self.postListTableView beginUpdates];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (u_long i = self.posts.count - posts.count; i < self.posts.count; i++) {
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
        
//        if (self.pageIndex == 0) {
//            [self performSelector:@selector(scrollTableViewToTop:) withObject:self afterDelay:0];
//            
//            [self stopAllLoadingAnimations];
//        }
    }
    
    [self stopAllLoadingAnimations];
}

- (void)stopAllLoadingAnimations {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self.postListTableView.infiniteScrollingView stopAnimating];
    [self.postListTableView.pullToRefreshView stopAnimating];
}

- (void)scrollTableViewToTop:(id)nothing {
    // [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//    self.postListTableView.hidden = NO;
    [self.postListTableView scrollRectToVisible:CGRectMake(1, 60, 1, 1) animated:YES];
//    [self.postListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
//                                  atScrollPosition:UITableViewScrollPositionNone
//                                          animated:NO];
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
    [self stopAllLoadingAnimations];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据加载失败"
                                                    message:@"请检查网络连接是否可用"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
    [alert show];

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
    
    PostInfo *post = [self.posts objectAtIndex:indexPath.row];
    //if (indexPath.section == 0) {
    GDPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (cell) {
        [cell prepareForReuse];
        [cell configureForPostInfo:post];
    }
    
    double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
    NSLog(@"cell: %f", timePassed_ms);
    
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDate *startDate = [NSDate date];
//
//    PostInfo *post = [self.posts objectAtIndex:indexPath.row];
//    
//    NSNumber *postIdNumber = [NSNumber numberWithInt:post.postId];
//    NSNumber *cached = [self.cellHeightCache objectForKey:postIdNumber];
//    if (cached != nil) {
//        // NSLog(@"cached  height: %@", cached);
//        double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
//        NSLog(@"cached height: %f", timePassed_ms);
//
//        return [cached doubleValue];
//    } else {
//        CGFloat calcHeight = [GDPostListTableViewCell cellHeightForPostInfo:post];
//        [self.cellHeightCache setObject:[NSNumber numberWithDouble:calcHeight] forKey:postIdNumber];
//        double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
//        NSLog(@"raw height: %f", timePassed_ms);
//
//        return calcHeight;
//    }
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostInfo *post = [self.posts objectAtIndex:indexPath.row];
    self.selectedPostId = post.postId;
    
    [self performSegueWithIdentifier:@"ViewPost" sender:self];
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