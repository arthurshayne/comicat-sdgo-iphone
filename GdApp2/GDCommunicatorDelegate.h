//
//  GDCommunicatorDelegate.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDCommunicatorDelegate <NSObject>
@optional
- (void)receivedHomeInfoJSON: (NSData *)objectNotation;
- (void)fetchHomeInfoFailedWithError: (NSError *)error;

- (void)receivedPostInfoJSON: (NSData *)objectNotation;
- (void)fetchPostInfoFailedWithError: (NSError *)error;

- (void)receivedUnitSearchResults: (NSData *)objectNotation;
- (void)searchUnitsWithError:(NSError *)error;
@end
