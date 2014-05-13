//
//  GDManager.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDManager.h"
#import "GDCommunicatorDelegate.h"
#import "GDInfoBuilder.h"


// TO BE DELETED
#import "UnitInfoShort.h"

@implementation GDManager
- (void)fetchHomeInfo {
    [self.communicator fetchHomeInfo];
}

- (void)fetchPostInfo: (int)postId {
    [self.communicator fetchPostInfo:postId];
}

- (void)searchUnitsWithKeyword:(NSString *)keyword {
    [self.communicator searchUnitsWithKeyword:keyword];
}

- (void)fetchPostListOfCategory:(int)gdCategory pageSize:(int)pageSize pageIndex:(int)pageIndex {
    [self.communicator fetchPostList:gdCategory pageSize:pageSize pageIndex:pageIndex];
}

#pragma mark - GDCommunicatorDelegate
// home
- (void)receivedHomeInfoJSON:(NSData *)objectNotation {
    NSError *error;
    HomeInfo *homeInfo = [GDInfoBuilder homeInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchingHomeInfoWithError:error];
    } else {
        [self.delegate didReceiveHomeInfo:homeInfo];
    }
}

// home error
- (void) fetchHomeInfoFailedWithError:(NSError *)error {
    [self.delegate fetchingHomeInfoWithError:error];
}

// post info
- (void)receivedPostInfoJSON:(NSData *)objectNotation {
    NSError *error;
    PostInfo *postInfo = [GDInfoBuilder postInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchingPostInfoWithError:error];
    } else {
        [self.delegate didReceivePostInfo:postInfo];
    }
}

// post info error
- (void) fetchPostInfoFailedWithError:(NSError *)error {
    [self.delegate fetchingPostInfoWithError:error];
}

// search unit
- (void)receivedUnitSearchResultsJSON:(NSData *)objectNotation {
    NSError *error;
    NSArray *units = [GDInfoBuilder unitInfoListFromJSON:objectNotation error:&error];
    
    [self.delegate didReceiveUnitSearchResults:units];
}

// search unit error
- (void)searchUnitsWithError:(NSError *)error {
    [self.delegate  searchUnitsWithError:error];
}

- (void)receivedPostListJSON:(NSData *)objectNotation {
    NSError *error;
    int category;
    NSArray *posts = [GDInfoBuilder postListFromJSON:objectNotation gdCategory:&category error:&error];
    
    [self.delegate didReceivePostList:posts ofGdCategory:category];
}

- (void)fetchPostListWithError:(NSError *)error {
    [self.delegate fetchPostListWithError:error];
}

@end
