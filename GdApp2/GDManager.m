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

#pragma mark - GDCommunicatorDelegate

- (void)receivedHomeInfoJSON:(NSData *)objectNotation {
    NSError *error;
    HomeInfo *homeInfo = [GDInfoBuilder homeInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchingHomeInfoWithError:error];
    } else {
        [self.delegate didReceiveHomeInfo:homeInfo];
    }
}

- (void) fetchHomeInfoFailedWithError:(NSError *)error {
    [self.delegate fetchingHomeInfoWithError:error];
}

- (void)receivedPostInfoJSON:(NSData *)objectNotation {
    NSError *error;
    PostInfo *postInfo = [GDInfoBuilder postInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchingPostInfoWithError:error];
    } else {
        [self.delegate didReceivePostInfo:postInfo];
    }
}

- (void) fetchPostInfoFailedWithError:(NSError *)error {
    [self.delegate fetchingPostInfoWithError:error];
}

- (void)receivedUnitSearchResults:(NSData *)objectNotation {
    NSError *error;
    NSArray *units = [GDInfoBuilder unitInfoListFromJSON:objectNotation error:&error];
    
    [self.delegate didReceiveUnitSearchResults:units];
}

- (void)searchUnitsWithError:(NSError *)error {
    [self.delegate  searchUnitsWithError:error];
}

@end
