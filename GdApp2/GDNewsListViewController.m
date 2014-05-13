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

#import "GDPostCategoryView.h"
#import "GDPostListTableViewCell.h"

@interface GDNewsListViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *gdCategoryList;
@property (weak, nonatomic) IBOutlet UITableView *postListTableView;

@property (strong, nonatomic) NSArray *gdCategories;

@property (strong, nonatomic) GDManager *manager;

@property int currentGdCategory;
@property (strong, nonatomic) NSDictionary *postsByDate;
@property (strong, nonatomic) NSArray *dateStrings;

// TODO: CACHE
@end

@implementation GDNewsListViewController

const CGFloat CATEGORY_ITEM_WIDTH = 55;
const CGFloat CATEGORY_ITEM_MARGIN = 5;

const int POST_LIST_PAGE_SIZE = 20;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareCategoryList];
    
    self.currentGdCategory = 0;
    [self.manager fetchPostListOfCategory:0 pageSize:POST_LIST_PAGE_SIZE pageIndex:0];
    
    [self.postListTableView registerClass:[GDPostListTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareCategoryList {
    for (int i = 0; i < self.gdCategories.count; i++) {
        int gdCategory = [(NSNumber *)[self.gdCategories objectAtIndex:i] intValue];
        GDPostCategoryView *gdcv = [[GDPostCategoryView alloc] initWithFrame:CGRectMake(CATEGORY_ITEM_MARGIN + i * (CATEGORY_ITEM_WIDTH + CATEGORY_ITEM_MARGIN), CATEGORY_ITEM_MARGIN, CATEGORY_ITEM_WIDTH, 22) fontSize:13];
        gdcv.gdPostCategory = gdCategory;
        gdcv.delegate = self;
        
        [self.gdCategoryList addSubview:gdcv];
    }
    
    self.gdCategoryList.contentSize =
        CGSizeMake(self.gdCategories.count * (CATEGORY_ITEM_WIDTH + CATEGORY_ITEM_MARGIN) + CATEGORY_ITEM_MARGIN, 10);
}

- (void)tappedOnCategoryViewWithCategory:(int)category {
    if (self.currentGdCategory != category) {
    // should clear the array
        self.currentGdCategory = category;
        
        self.postsByDate = nil;
        self.dateStrings = nil;
        
        [self.manager fetchPostListOfCategory:category pageSize:POST_LIST_PAGE_SIZE pageIndex:0];
    }
}

#pragma mark - GDManagerDelegate

- (void)didReceivePostList:(NSArray *)posts ofGdCategory:(int)category {
    NSLog(@"Category: %d", category);
    
    if (!self.postsByDate) {
        self.postsByDate = [[NSDictionary alloc] init];
    }
    
    if (!self.dateStrings) {
        self.dateStrings = [[NSArray alloc] init];
    }
    
    // didn't change since last change
    if (self.currentGdCategory == category) {
        // put in
        [self mergePosts:posts];
        
        // reload table
        [self.postListTableView reloadData];
    }
}

- (void)mergePosts:(NSArray *)posts {
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    nsdf.dateFormat = @"yyyy-MM-dd";

    NSMutableDictionary *postsByDateMutable = [NSMutableDictionary dictionaryWithDictionary:self.postsByDate];
    for (PostInfo *p in posts) {
        NSString *dateString = [nsdf stringFromDate:p.created];
        NSArray *existingPosts = [postsByDateMutable objectForKey:dateString];
        NSMutableArray *withNewPosts;
        if (existingPosts == nil || existingPosts.count == 0) {
            withNewPosts = [[NSMutableArray alloc] init];
        } else {
            withNewPosts = [NSMutableArray arrayWithArray:existingPosts];
        }
        
        [postsByDateMutable setObject:[withNewPosts arrayByAddingObject:p] forKey:dateString];
    }
    
    self.dateStrings = [postsByDateMutable.allKeys sortedArrayUsingComparator:^(id a, id b) {
        return -[a compare:b options:NSNumericSearch];
    }];
    
    self.postsByDate = [NSDictionary dictionaryWithDictionary:postsByDateMutable];
}

- (void)fetchPostListWithError:(NSError *)error {
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dateStrings.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dateStrings objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: build array for post count;
    NSString *dateString = [self.dateStrings objectAtIndex:section];
    NSArray *posts = [self.postsByDate objectForKey:dateString];
    return posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *startDate = [NSDate date];
    
    GDPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];

    NSString *dateString = [self.dateStrings objectAtIndex:indexPath.section];
    NSArray *posts = [self.postsByDate objectForKey:dateString];
    
    PostInfo *post = [posts objectAtIndex:indexPath.row];
    
    [cell configureForPostInfo:post];
    
    double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
    NSLog(@"cell: %f", timePassed_ms);
    
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *startDate = [NSDate date];
    
    NSString *dateString = [self.dateStrings objectAtIndex:indexPath.section];
    NSArray *posts = [self.postsByDate objectForKey:dateString];
    
    PostInfo *post = [posts objectAtIndex:indexPath.row];

    double timePassed_ms = [startDate timeIntervalSinceNow] * 1000.0;
    NSLog(@"height: %f", timePassed_ms);

    
    return [GDPostListTableViewCell cellHeightForPostInfo:post];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 16;
}

- (PostInfo *)findPostByIndexPath:(NSIndexPath *)indexPath {
    NSString *dateString = [self.dateStrings objectAtIndex:indexPath.section];
    NSArray *posts = [self.postsByDate objectForKey:dateString];
    
    return [posts objectAtIndex:indexPath.row];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 24;
//}

@end

/*
 TODO:
- selected category
- view all (not single category)
 */
