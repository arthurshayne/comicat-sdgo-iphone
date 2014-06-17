//
//  PostInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoCoding.h"

@interface PostInfo : NSObject
@property int postId;
@property (strong, nonatomic) NSString *title;
@property int gdPostType;
@property int gdPostCategory;
@property (strong, nonatomic) NSString *videoHost;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *contentHTML;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *createdBy;

@property (strong, nonatomic) NSString *userName;
@property (nonatomic) uint authorId;
@property (strong, nonatomic) NSString *briefText;

@property (nonatomic) uint clicks;

@property uint listStyle;

+ (PostInfo *)postWithTitle:(NSString *)title andCategory:(int)gdCategory;

@end
