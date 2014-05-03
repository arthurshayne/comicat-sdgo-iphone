//
//  GDInfoBuilder.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDInfoBuilder.h"
#import "HomeInfo.h"
#import "CarouselInfo.h"
#import "VideoListItem.h"

@implementation GDInfoBuilder
+ (HomeInfo *) homeInfoFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *tempError = nil;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                                 options:0
                                                                   error: &tempError];
    if (tempError) {
        *error = tempError;
        return nil;
    }
    
    HomeInfo *homeInfo = [[HomeInfo alloc] init];
    
    homeInfo.success = [(NSNumber *)[parsed objectForKey:@"success"] boolValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     
    homeInfo.generated = [dateFormatter dateFromString:(NSString *)[parsed objectForKey:@"generated"]];
    
    // carousel
    NSArray *carouselFromDictionary = [parsed objectForKey:@"carousel"];
    NSMutableArray *carousel = [[NSMutableArray alloc] init];
    for (NSDictionary *d in carouselFromDictionary) {
        CarouselInfo *tempCi = [[CarouselInfo alloc] init];
        tempCi.title = [d objectForKey:@"title"];
        tempCi.imageURL = [d objectForKey:@"imageURL"];
        tempCi.gdPostType = [(NSNumber *)[d objectForKey:@"gdPostType"] intValue];
        tempCi.postId = [(NSNumber *)[d objectForKey:@"objectId"] intValue];
        [carousel addObject:tempCi];
    }
    homeInfo.carousel = carousel;
    
    // videolist
    NSArray *videoListFromDictionary = [parsed objectForKey:@"videoList"];
    NSMutableArray *videoList = [[NSMutableArray alloc] init];
    for (NSDictionary *d in videoListFromDictionary) {
        VideoListItem *tempVli = [[VideoListItem alloc] init];
        tempVli.title = [d objectForKey:@"title"];
        tempVli.title2 = [d objectForKey:@"title2"];
        tempVli.imageURL = [d objectForKey:@"imageURL"];
//        tempVli.videoHost = [d objectForKey:@"videoHost"];
//        tempVli.videoId = [d objectForKey:@"videoId"];
        tempVli.gdPostCategory = [(NSNumber *)[d objectForKey:@"gdPostCategory"] intValue];
        tempVli.postId = [(NSNumber *)[d objectForKey:@"postId"] intValue];
        tempVli.created = [dateFormatter dateFromString:(NSString *)[d objectForKey:@"created"]];

        [videoList addObject:tempVli];
    }
    homeInfo.videoList = videoList;
    
    return homeInfo;
}
@end
