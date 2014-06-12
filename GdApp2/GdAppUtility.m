//
//  Utility.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/9/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GdAppUtility.h"

@implementation GdAppUtility

+ (UIColor *)UIColorFromRGB:(int)rgbHexValue {
    return [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbHexValue & 0xFF))/255.0 alpha:1.0];
}

+ (NSString *)dateStringByDay:(NSDate *)date {
    NSString * prettyTimestamp;
    
    float delta = [date timeIntervalSinceNow] * -1;
    
    if (delta < 86400) {
        prettyTimestamp = @"今天";
    } else if (delta < ( 86400 * 2 ) ) {
        prettyTimestamp = @"昨天";
    } else if (delta < ( 86400 * 7 ) ) {
        prettyTimestamp = [NSString stringWithFormat:@"%d天前", (int) floor(delta/86400.0) ];
    } else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    }
    
    return prettyTimestamp;

}

+ (UIColor *)appTintColor {
    static UIColor *appTintColor;
    if (!appTintColor) {
        appTintColor = [UIColor colorWithRed:1 green:0.29 blue:0.27 alpha:1];
    }
    return appTintColor;
}

@end