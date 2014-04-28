//
//  PostInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListItem : NSObject
@property int id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *title2; // display on image if exists
@property (strong, nonatomic) NSString *imageURL;
@property int gdPostCategory;
@property (strong, nonatomic) NSString *videoHost;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *createdBy;
@end
