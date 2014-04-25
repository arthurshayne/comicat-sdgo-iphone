//
//  GDManager.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDCommunicator.h"
#import "GDCommunicatorDelegate.h"
#import "GDManagerDelegate.h"

@interface GDManager : NSObject<GDCommunicatorDelegate>
@property (strong, nonatomic) GDCommunicator *communicator;
@property (weak, nonatomic) id<GDManagerDelegate> delegate;

- (void)fetchHomeInfo;
@end
