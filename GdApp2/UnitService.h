//
//  UnitService.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/14/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitService : NSObject

+ (void)markUnitViewed:(NSString *)unitId;
+ (BOOL)isUnitViewed:(NSString *)unitId;
+ (BOOL)areUnitsAllViewed:(NSArray *)unitIds;

@end
