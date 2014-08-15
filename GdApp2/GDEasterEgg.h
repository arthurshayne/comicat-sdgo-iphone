//
//  GDEasterEgg.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDEasterEgg : NSObject

+ (void)turnOnEasterEgg;
+ (void)turnOffEasterEgg;

+ (void)proceedEasterEggDiscovery:(NSString *)unitId;

+ (BOOL)isEasterEggEnabled;

@end
