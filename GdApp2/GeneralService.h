//
//  GeneralService.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/14/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralService : NSObject

+ (void)markUnitViewedForEasterEgg:(NSString *)unitId;
+ (BOOL)isUnitViewedForEasterEgg:(NSString *)unitId;
+ (void)clearEaterEggUnitViews;

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (BOOL)readBooleanForKey:(NSString *)key;

@end
