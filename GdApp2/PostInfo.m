//
//  PostInfo.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "PostInfo.h"

@implementation PostInfo
+ (PostInfo *)postWithTitle:(NSString *)title andCategory:(int)gdCategory {
    PostInfo *p = [[PostInfo alloc] init];
    
    p.title = title;
    p.gdPostCategory = gdCategory;
    
    return p;
}
@end
