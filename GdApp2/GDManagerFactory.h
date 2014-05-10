//
//  GDManagerFactory.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDManagerDelegate.h"
#import "GDManager.h"

@interface GDManagerFactory : NSObject
+ (GDManager *)getGDManagerWithDelegate:(id<GDManagerDelegate>)delegate;
@end
