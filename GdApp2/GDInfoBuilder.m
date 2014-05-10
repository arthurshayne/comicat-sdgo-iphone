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
#import "PostInfo.h"
#import "UnitInfoShort.h"

@interface GDInfoBuilder()
+(NSDateFormatter *) dateFormatter;
@end

@implementation GDInfoBuilder

+(NSDateFormatter *) dateFormatter {
    static NSDateFormatter* foo = nil;
    if (!foo) {
        foo = [[NSDateFormatter alloc] init];
        [foo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return foo;
}

+ (HomeInfo *)homeInfoFromJSON:(NSData *)objectNotation error:(NSError **)error {
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
    
    NSDateFormatter *dateFormatter = [GDInfoBuilder dateFormatter];
     
    homeInfo.generated = [dateFormatter dateFromString:(NSString *)[parsed objectForKey:@"generated"]];
    
    // carousel
    NSArray *carouselFromDictionary = [parsed objectForKey:@"carousel"];
    NSMutableArray *carousel = [[NSMutableArray alloc] init];
    for (NSDictionary *d in carouselFromDictionary) {
        CarouselInfo *tempCi = [[CarouselInfo alloc] init];
        tempCi.title = [d objectForKey:@"title"];
        tempCi.imageURL = [d objectForKey:@"imageURL"];
        tempCi.gdPostType = [(NSNumber *)[d objectForKey:@"gdPostType"] intValue];
        tempCi.postId = [(NSNumber *)[d objectForKey:@"postId"] intValue];
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

+ (PostInfo *)postInfoFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *tempError = nil;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                           options:0
                                                             error: &tempError];
    if (tempError) {
        *error = tempError;
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [GDInfoBuilder dateFormatter];

    PostInfo *post = [[PostInfo alloc] init];
    
//    post.postId = [(NSNumber *)[parsed objectForKey:@"id"] intValue];
    post.title = [parsed objectForKey:@"title"];
    post.gdPostType = [(NSNumber *)[parsed objectForKey:@"gdPostType"] intValue];
    post.gdPostCategory = [(NSNumber *)[parsed objectForKey:@"gdPostCategory"] intValue];
    post.contentHTML = [parsed objectForKey:@"contentHtml"];
    post.videoHost = [parsed objectForKey:@"videoHost"];
    post.videoId = [parsed objectForKey:@"videoId"];
    post.created = [dateFormatter dateFromString:(NSString *)[parsed objectForKey:@"created"]];
    post.createdBy = [parsed objectForKey:@"createdBy"];
    
    return post;
}

+ (NSArray *)unitInfoListFromJSON:(NSData *)objectNotation error:(NSError **)error {
    // returns Array of UnitInfoShort
    NSError *tempError = nil;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                           options:0
                                                             error: &tempError];
    if (tempError) {
        *error = tempError;
        return nil;
    }

    BOOL success = [(NSNumber *)[parsed objectForKey:@"success"] boolValue];
    if (!success) {
        return nil;
    }
    
    NSArray *unitsDictionary = [parsed objectForKey:@"units"];
    NSMutableArray *units = [[NSMutableArray alloc] init];
    for (NSDictionary *d in unitsDictionary) {
        UnitInfoShort *uis = [[UnitInfoShort alloc] init];
        uis.unitId = [d objectForKey:@"unitId"];
        uis.modelName = [d objectForKey:@"modelName"];
        uis.rank = [d objectForKey:@"rank"];
        uis.warType = [d objectForKey:@"warType"];
        uis.originTitleShort = [d objectForKey:@"originTitleShort"];
        uis.origin = [(NSNumber *)[d objectForKey:@"origin"] intValue];
        uis.rating = [(NSNumber *)[d objectForKey:@"rating"] floatValue];
        
        [units addObject:uis];
    }
    return units;
}
@end
