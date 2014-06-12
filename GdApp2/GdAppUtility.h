//
//  Utility.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/9/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GdAppUtility : NSObject
+ (UIColor *)UIColorFromRGB:(int)rgbHex;
+ (NSString *)dateStringByDay:(NSDate *)date;
+ (UIColor *)appTintColor;
@end
