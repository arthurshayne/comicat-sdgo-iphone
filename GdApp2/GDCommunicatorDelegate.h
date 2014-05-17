//
//  GDCommunicatorDelegate.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDCommunicatorDelegate <NSObject>
- (void)receivedHomeInfoJSON: (NSData *)objectNotation;
- (void)fetchHomeInfoFailedWithError: (NSError *)error;

- (void)receivedPostInfoJSON: (NSData *)objectNotation;
- (void)fetchPostInfoFailedWithError: (NSError *)error;

- (void)receivedUnitSearchResultsJSON: (NSData *)objectNotation;
- (void)searchUnitsWithError:(NSError *)error;

- (void)receivedPostListJSON: (NSData *)objectNotation;
- (void)fetchPostListWithError:(NSError *)error;

- (void)receivedVideoListJSON: (NSData *)objectNotation;
- (void)fetchVideoListWithError:(NSError *)error;
@end
