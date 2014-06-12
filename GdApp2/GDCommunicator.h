//
//  GDCommunicator.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDCommunicatorDelegate;

@interface GDCommunicator : NSObject
@property (weak, nonatomic) id<GDCommunicatorDelegate> delegate;

- (void)fetchHomeInfo;
- (void)fetchPostInfo: (int)postId;
- (void)searchUnitsWithKeyword: (NSString *)keyword;
- (void)fetchPostList:(uint)gdCategory pageSize:(uint)pageSize pageIndex:(uint)pageIndex;
- (void)fetchVideoList:(uint)gdCategory pageSize:(uint)pageSize pageIndex:(uint)pageIndex;
- (void)fetchUnitInfo: (NSString *)unitId;
- (void)fetchUnitCountByOrigin;

@end
