//
//  GDManagerFactory.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDManagerFactory.h"

@implementation GDManagerFactory
+ (GDManager *)gdManagerWithDelegate:(id<GDManagerDelegate>)delegate {
    GDManager *manager = [[GDManager alloc] init];
    manager.communicator = [[GDCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.delegate = delegate;

    return manager;
}
@end
