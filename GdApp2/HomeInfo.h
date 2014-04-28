//
//  SdgundamHomeInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeInfo : NSObject
@property BOOL success;
@property (strong, nonatomic) NSDate *generated;
@property (strong, nonatomic) NSArray *carousel;    // of CarouselInfo
@property (strong, nonatomic) NSArray *videoList;    // of VideoListItem

@end
