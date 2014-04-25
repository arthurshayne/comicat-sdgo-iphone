//
//  PostInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostInfo : NSObject
@property int id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSNumber *gdPostType;   // post: 1, video: 2
@property (strong, nonatomic) NSString *videoHost;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *contentHtml;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *lastModified;
@property (strong, nonatomic) NSString *createdBy;
@end
