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

@implementation GDManager

#pragma mark - Private methods for FileCaching

static const NSString *HOME_CACHE_FILE = @"home.cache";
static const uint HOME_CACHE_LIFETIME = 43200; // seconds, 12 hours

- (void)fetchHomeInfo:(BOOL)force {
    if (force) {
        [self.communicator fetchHomeInfo];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:@"home.cache"];
        HomeInfo *cachedHomeInfo = [HomeInfo objectWithContentsOfFile:cachedFile.path];
        if (cachedHomeInfo && fabs([cachedHomeInfo.generated timeIntervalSinceNow]) < HOME_CACHE_LIFETIME) {
            [self.delegate didReceiveHomeInfo:cachedHomeInfo];
        } else {
            // not cached, call the API
            [self.communicator fetchHomeInfo];
        }
    }
}

- (void)fetchPostInfo: (int)postId {
    [self.communicator fetchPostInfo:postId];
}

- (void)searchUnitsWithKeyword:(NSString *)keyword {
    [self.communicator searchUnitsWithKeyword:keyword];
}

- (void)fetchPostListOfCategory:(uint)gdCategory pageSize:(uint)pageSize pageIndex:(uint)pageIndex {
    [self.communicator fetchPostList:gdCategory pageSize:pageSize pageIndex:pageIndex];
}

- (void)fetchVideoListOfCategory:(uint)gdCategory pageSize:(uint)pageSize pageIndex:(uint)pageIndex {
    [self.communicator fetchVideoList:gdCategory pageSize:pageSize pageIndex:pageIndex];
}

- (void)fetchUnitInfo:(NSString *)unitId {
    [self.communicator fetchUnitInfo:unitId];
}

- (void)fetchUnitCountByOrigin {
    [self.communicator fetchUnitCountByOrigin];
}

- (void)fetchUnitsByOrigin:(NSString *)origin; {
    [self.communicator fetchUnitsByOrigin:origin];
}

#pragma mark - GDCommunicatorDelegate
// home
- (void)receivedHomeInfoJSON:(NSData *)objectNotation {
    NSError *error;
    HomeInfo *homeInfo = [GDInfoBuilder homeInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchingHomeInfoWithError:error];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:@"home.cache"];
        [homeInfo writeToFile:cachedFile.path atomically:YES];
        
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

// post list
- (void)receivedPostListJSON:(NSData *)objectNotation {
    NSError *error;
    int category;
    NSArray *posts = [GDInfoBuilder postListFromJSON:objectNotation gdCategory:&category error:&error];
    
    [self.delegate didReceivePostList:posts ofGdCategory:category];
}

// post list error
- (void)fetchPostListWithError:(NSError *)error {
    [self.delegate fetchPostListWithError:error];
}

// video list
- (void)receivedVideoListJSON:(NSData *)objectNotation {
    NSError *error;
    int category;
    NSArray *videos = [GDInfoBuilder videoListFromJSON:objectNotation gdCategory:&category error:&error];
    
    [self.delegate didReceiveVideoList:videos ofGdCategory:category];
}

// video list error
- (void)fetchVideoListWithError:(NSError *)error {
    [self.delegate fetchVideoListWithError:error];
}

// unit info
- (void)receivedUnitInfoJSON:(NSData *)objectNotation {
    NSError *error;
    UnitInfo *unitInfo = [GDInfoBuilder unitInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchUnitInfoWithError:error];
    } else {
        [self.delegate didReceiveUnitInfo:unitInfo];
    }
}

// post info error
- (void) fetchUnitInfoFailedWithError:(NSError *)error {
    [self.delegate fetchUnitInfoWithError:error];
}

// unit count by origin
- (void)receivedUnitCountByOriginJSON:(NSData *)objectNotation {
    NSError *error;
    NSDictionary *unitCountByOrigin = [GDInfoBuilder unitCountByOriginFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchUnitCountByOriginWithError:error];
    } else {
        [self.delegate didReceiveUnitCountByOrigin:unitCountByOrigin];
    }
}

// unit count by origin error
- (void)fetchUnitCountByOriginFailedWithError:(NSError *)error {
    [self.delegate fetchUnitCountByOriginWithError:error];
}

// units by origin
- (void)receivedUnitsOfOriginJSON:(NSData *)objectNotation {
    NSError *error;
    NSArray *units = [GDInfoBuilder unitInfoListFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchUnitsByOriginWithError:error];
    } else {
        [self.delegate didReceiveUnitsOfOrigin:units];
    }
}

// units by origin error
- (void)fetchUnitsByOriginFailedWithError:(NSError *)error {
    [self.delegate fetchUnitsByOriginWithError:error];
}

@end
