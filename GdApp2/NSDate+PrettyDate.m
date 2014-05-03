//
//  NSDate+PrettyDate.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/3/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "NSDate+PrettyDate.h"

@implementation NSDate (PrettyDate)
- (NSString *)prettyDate
{
    NSString * prettyTimestamp;
    
    float delta = [self timeIntervalSinceNow] * -1;
    
    if (delta < 60) {
        prettyTimestamp = @"刚才";
    } else if (delta < 120) {
        prettyTimestamp = @"1分钟前";
    } else if (delta < 3600) {
        prettyTimestamp = [NSString stringWithFormat:@"%d分钟前", (int) floor(delta/60.0) ];
    } else if (delta < 7200) {
        prettyTimestamp = @"1小时前";
    } else if (delta < 86400) {
        prettyTimestamp = [NSString stringWithFormat:@"%d小时前", (int) floor(delta/3600.0) ];
    } else if (delta < ( 86400 * 2 ) ) {
        prettyTimestamp = @"昨天";
    } else if (delta < ( 86400 * 7 ) ) {
        prettyTimestamp = [NSString stringWithFormat:@"%d天前", (int) floor(delta/86400.0) ];
    } else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self]];
    }
    
    return prettyTimestamp;
}
@end
