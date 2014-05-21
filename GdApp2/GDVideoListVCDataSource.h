//
//  GDVideoListDataSource.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/20/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDManagerDelegate.h"
#import "GDVideoListDSDelegate.h"
#import "VideoListItem.h"

@interface GDVideoListVCDataSource : NSObject <UICollectionViewDataSource, GDManagerDelegate>

@property (readonly) uint pageIndex;
@property uint gdCategory;

@property (readonly, getter = isBusy) BOOL busy;

@property (weak, nonatomic) id<GDVideoListDSDelegate> delegate;

- (instancetype)initWithGDCategory:(uint)gdCategory;

- (void)reloadData;
- (void)loadMore;

- (VideoListItem *)vliForIndexPath:(NSIndexPath *)indexPath;
@end
