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
@end
