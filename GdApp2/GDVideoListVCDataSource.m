//
//  GDVideoListDataSource.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/20/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDVideoListVCDataSource.h"
#import "GDManager.h"
#import "GDManagerFactory.h"
#import "GDVideoListCollectionViewCell.h"

@interface GDVideoListVCDataSource ()

@property (strong, nonatomic) GDManager *manager;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic) BOOL noMoreData;
@end

@implementation GDVideoListVCDataSource

static const int POST_LIST_PAGE_SIZE = 20;
static const NSString *CELL_IDENTIFIER = @"VideoListTableCell";

#pragma mark - Properties

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory getGDManagerWithDelegate:self];
    }
    return _manager;
}


- (instancetype)initWithGDCategory:(uint)gdCategory {
    self = [super init];
    if (self) {
        _gdCategory = gdCategory;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)reloadData {
    self.noMoreData = NO;
    
    _pageIndex = 0;
    _posts = nil;
    
    [self.delegate willLoadDataFromGDCategory:_gdCategory isReloading:YES];
    
    [self.manager fetchVideoListOfCategory:self.gdCategory pageSize:POST_LIST_PAGE_SIZE pageIndex:self.pageIndex];
}

- (void)loadMore {
    _pageIndex++;
    
    [self.delegate willLoadDataFromGDCategory:_gdCategory isReloading:NO];
    
    [self.manager fetchVideoListOfCategory:self.gdCategory pageSize:POST_LIST_PAGE_SIZE pageIndex:self.pageIndex];
}

- (VideoListItem *)vliForIndexPath:(NSIndexPath *)indexPath {
    return (VideoListItem*)[self.posts objectAtIndex:indexPath.row];
}

#pragma mark - GDManagerDelegate

- (void)didReceiveVideoList:(NSArray *)newPosts ofGdCategory:(uint)gdCategory {
    BOOL justReloaded = (!_posts);
    
    if (newPosts.count < POST_LIST_PAGE_SIZE || newPosts.count == 0) {
        // TODO: its over...
        self.noMoreData = YES;
        [self.delegate noMoreDataFromGDCategory:gdCategory];
    }
    
    if(_posts == nil) {
        _posts = [[NSMutableArray alloc] init];
    }
    NSUInteger numberOfPostsBeforeAppend = _posts.count;

    [self appendPosts:newPosts];
    
    [self.delegate dataDidPrepared:newPosts.count
                    previouslyHave:numberOfPostsBeforeAppend
                      ofGDCategory:gdCategory
                      needToReload:justReloaded];
}

- (void)fetchVideoListWithError:(NSError *)error {
    [self.delegate dataSourceWithError:error];
}

- (void)appendPosts:(NSArray *)posts {
    [_posts addObjectsFromArray:posts];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"indexPath.row: %d", indexPath.row);
    
    GDVideoListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:[CELL_IDENTIFIER copy] forIndexPath:indexPath];
    // GDVideoListCollectionViewCell *cell = [[GDVideoListCollectionViewCell alloc] init];
    
    VideoListItem *vli = (VideoListItem*)[self.posts objectAtIndex:indexPath.row];
    //    NSLog(@"should: %@, %@", vli.title, vli.title2);
    
    if (vli) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.videoListItem = vli;
        
        // [cell setNeedsLayout];
    }
    return cell;
}


@end
