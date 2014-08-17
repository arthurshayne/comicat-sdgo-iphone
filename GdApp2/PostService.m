//
//  VideoService.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/17/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "PostService.h"
#import <LevelDB.h>

@implementation PostService

+ (LevelDB *)ldbInstance {
    static LevelDB *sharedLDBInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLDBInstance = [LevelDB databaseInLibraryWithName:@"PostService.ldb"];
    });
    return sharedLDBInstance;
}

static NSString *VideoViewedPrefix = @"VIDEO_VIEWED_%d";

+ (void)markVideoLastViewed:(int)postId {
    [[[self class] ldbInstance]
     setObject:[NSDate date] forKey:[NSString stringWithFormat:VideoViewedPrefix, postId]];
}

+ (NSDate *)videoLastViewedAt:(int)postId {
    return (NSDate *)[[[self class] ldbInstance] objectForKey:[NSString stringWithFormat:VideoViewedPrefix, postId]];
}

@end
