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
@end
