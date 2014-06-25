//
//  SdgundamManagerDelegate.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeInfo.h"
#import "PostInfo.h"
#import "UnitInfo.h"
#import "UnitList.h"

@protocol GDManagerDelegate <NSObject>
@optional
- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo;
- (void)fetchingHomeInfoWithError:(NSError *)error;

- (void)didReceivePostInfo:(PostInfo *)postInfo;
- (void)fetchingPostInfoWithError:(NSError *)error;

- (void)didReceiveUnitSearchResults:(NSArray *)units;
- (void)searchUnitsWithError:(NSError *)error;

- (void)didReceivePostList:(NSArray *)posts ofGdCategory:(uint)category;
- (void)fetchPostListWithError:(NSError *)error;

- (void)didReceiveVideoList:(NSArray *)posts ofGdCategory:(uint)category;
- (void)fetchVideoListWithError:(NSError *)error;

- (void)didReceiveUnitInfo:(UnitInfo *)unitInfo;
- (void)fetchUnitInfoWithError:(NSError *)error;

- (void)didReceiveUnitCountByOrigin:(NSDictionary *)unitCountByOrigin;
- (void)fetchUnitCountByOriginWithError:(NSError *)error;

- (void)didReceiveUnitList:(UnitList *)list ofOrigin:(NSString *)origin;
- (void)fetchUnitsByOriginWithError:(NSError *)error;

@end
