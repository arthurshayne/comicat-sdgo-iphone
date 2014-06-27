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
#import "OriginInfo.h"
#import "GDHasNewOriginResult.h"

@interface GDManager ()

// @property (strong, nonatomic) NSDate *

@end

@implementation GDManager

#pragma mark - Private methods for FileCaching

static const NSString *HOME_CACHE_FILE = @"home.cache";
static const uint HOME_CACHE_LIFETIME = 300; // seconds, 5 min

static const NSString *UNIT_INFO_CACHE_FILE = @"unit-%@.cache";
static const uint UNIT_INFO_LIFETIME = 43200;   // seconds, 0.5 day

// static const uint UNIT_INFO_CHECK_UPDATE_INTERVAL = 600;   // seconds, 10 min

static const NSString *ORIGINS_FILE = @"origins.cache";

static const NSString *UNITS_BY_ORIGIN_CACHE_FILE = @"units-by-origin-%@.cache";
static const NSString *UNIT_COUNT_BY_ORIGIN_CACHE_FILE = @"unit-count-by-origin.cache";

- (void)fetchHomeInfo:(BOOL)force {
    if (force) {
        [self.communicator fetchHomeInfo];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:[HOME_CACHE_FILE copy]];
        HomeInfo *cachedHomeInfo = [HomeInfo objectWithContentsOfFile:cachedFile.path];
        if (cachedHomeInfo) {
            [self.delegate didReceiveHomeInfo:cachedHomeInfo];
            
            if (fabs([cachedHomeInfo.generated timeIntervalSinceNow]) > HOME_CACHE_LIFETIME) {
                // data expired, call API
                [self.communicator fetchHomeInfo];
            }
        } else {
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

- (void)fetchUnitInfo:(NSString *)unitId force:(BOOL)force {
    if (force) {
        [self.communicator fetchUnitInfo:unitId];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:[NSString stringWithFormat:[UNIT_INFO_CACHE_FILE copy], unitId]];
        UnitInfo *cachedUnitInfo= [UnitInfo objectWithContentsOfFile:cachedFile.path];
        if (cachedUnitInfo) {
            [self.delegate didReceiveUnitInfo:cachedUnitInfo];
            
            if (fabs([cachedUnitInfo.generated timeIntervalSinceNow]) > UNIT_INFO_LIFETIME) {
                // data expired, call API
                [self.communicator fetchUnitInfo:unitId];
            }
        } else {
            [self.communicator fetchUnitInfo:unitId];
        }
    }
}

- (void)fetchUnitsByOrigin:(NSString *)origin force:(BOOL)force {
    if (force) {
        [self.communicator fetchUnitsByOrigin:origin];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:[NSString stringWithFormat:[UNITS_BY_ORIGIN_CACHE_FILE copy], origin]];
        UnitList *list = [UnitList objectWithContentsOfFile:cachedFile.path];
        if (list) {
            [self.delegate didReceiveUnitList:list ofOrigin:origin];
            
            if (fabs([list.generated timeIntervalSinceNow]) > UNIT_INFO_LIFETIME) {
                [self.communicator fetchUnitsByOrigin:origin];
            }
        } else {
            [self.communicator fetchUnitsByOrigin:origin];
        }
    }
}

- (NSArray *)getUnitOrigins {
    // read the file
    NSURL *originsURL = [GDAppUtility pathForDocumentsFile:[ORIGINS_FILE copy]];
    GDHasNewOriginResult *checkResult = [GDHasNewOriginResult objectWithContentsOfFile:originsURL.path];
    
    NSArray *allOrigins;
    if (checkResult) {
        allOrigins = checkResult.origins;
    } else {
        // no file, use built in
        allOrigins = [OriginInfo builtInOrigins];
    }
    
    return allOrigins;
}

- (void)checkForOriginUpdate:(BOOL)force {
    if (force) {
        [self.communicator hasNewOrigin:0];
    } else {
        [self.communicator hasNewOrigin:(uint)(self.getUnitOrigins.count)];
    }
    
}


#pragma mark - GDCommunicatorDelegate
// home
- (void)receivedHomeInfoJSON:(NSData *)objectNotation {
    NSError *error;
    HomeInfo *homeInfo = [GDInfoBuilder homeInfoFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchingHomeInfoWithError:error];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:[HOME_CACHE_FILE copy]];
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
- (void)fetchPostInfoFailedWithError:(NSError *)error {
    [self.delegate fetchingPostInfoWithError:error];
}

// search unit
- (void)receivedUnitSearchResultsJSON:(NSData *)objectNotation {
    NSError *error;
    UnitList *list = [GDInfoBuilder unitListFromJSON:objectNotation error:&error];
    
    [self.delegate didReceiveUnitSearchResults:list.units];
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
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:[NSString stringWithFormat:[UNIT_INFO_CACHE_FILE copy], unitInfo.unitId]];
        [unitInfo writeToFile:cachedFile.path atomically:YES];
        
        [self.delegate didReceiveUnitInfo:unitInfo];
    }
}

// post info error
- (void) fetchUnitInfoFailedWithError:(NSError *)error {
    [self.delegate fetchUnitInfoWithError:error];
}

// units by origin
- (void)receivedUnitsOfOriginJSON:(NSData *)objectNotation {
    NSError *error;
    UnitList *list = [GDInfoBuilder unitListFromJSON:objectNotation error:&error];
    
    if (error) {
        [self.delegate fetchUnitsByOriginWithError:error];
    } else {
        NSURL *cachedFile = [GDAppUtility pathForDocumentsFile:[NSString stringWithFormat:[UNITS_BY_ORIGIN_CACHE_FILE copy], list.origin]];
        [list writeToFile:cachedFile.path atomically:YES];

        [self.delegate didReceiveUnitList:list ofOrigin:list.origin];
        
        // check if origin info is correct
        uint numberOfUnits = (uint)list.units.count;
        // find origin
        for (OriginInfo *origin in [self getUnitOrigins]) {
            if ([origin.originIndex isEqualToString:list.origin] &&
                origin.numberOfUnits != numberOfUnits) {
                [self checkForOriginUpdate:YES];
                break;
            }
        }
    }
}

// units by origin error
- (void)fetchUnitsByOriginFailedWithError:(NSError *)error {
    [self.delegate fetchUnitsByOriginWithError:error];
}

// has new origin
- (void)receivedHasNewOriginJSON:(NSData *)objectNotation {
    // TODO: if updated, update local caching file, and mark "Unit" tab a badge
    NSError *error;
    GDHasNewOriginResult *result = [GDInfoBuilder hasNewOriginResultFromJSON:objectNotation error:&error];
    
    if (error) {
        // do nothing
    } else {
        // has update
        if (result.result && result.origins) {
            NSURL *originsURL = [GDAppUtility pathForDocumentsFile:[ORIGINS_FILE copy]];
            [result writeToFile:originsURL.path atomically:YES];
        }
    }
}

// has new origin error
- (void)invokeHasNewOriginFailedWithError:(NSError *)error {
    // do nothing
}

@end
