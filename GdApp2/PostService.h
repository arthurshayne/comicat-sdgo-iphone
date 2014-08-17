//
//  VideoService.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/17/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostService : NSObject

+ (void)markVideoLastViewed:(int)postId;
+ (NSDate *)videoLastViewedAt:(int)postId;


@end
