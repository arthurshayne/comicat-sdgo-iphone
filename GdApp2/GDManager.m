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
- (void)fetchHomeInfo {
    [self.communicator fetchHomeInfo];
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

@end
