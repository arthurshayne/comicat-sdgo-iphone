//
//  PostInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostInfo : NSObject
@property int postId;
@property (strong, nonatomic) NSString *title;
@property NSUInteger gdPostType;
@property NSUInteger gdPostCategory;
@property (strong, nonatomic) NSString *videoHost;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *contentHTML;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *createdBy;

+ (PostInfo *)postWithTitle:(NSString *)title andCategory:(NSUInteger)category;

@end
