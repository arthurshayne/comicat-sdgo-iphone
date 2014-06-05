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
#import "UnitInfo.h"

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
    
    // postList
    NSArray *postListFromDictionary = [parsed objectForKey:@"postList"];
    NSMutableArray *postList = [[NSMutableArray alloc] init];
    for (NSDictionary *d in postListFromDictionary) {
        PostInfo *tempPI = [[PostInfo alloc] init];
        tempPI.title = [d objectForKey:@"title"];
        tempPI.gdPostCategory = [(NSNumber *)[d objectForKey:@"gdPostCategory"] intValue];
        tempPI.postId = [(NSNumber *)[d objectForKey:@"postId"] intValue];
        tempPI.created = [dateFormatter dateFromString:(NSString *)[d objectForKey:@"created"]];
        tempPI.listStyle = [(NSNumber *)[d objectForKey:@"style"] unsignedIntValue];
        
        [postList addObject:tempPI];
    }
    homeInfo.postList = postList;
    
    // units
    NSArray *unitsFromDictionary = [parsed objectForKey:@"units"];
    NSMutableArray *units = [[NSMutableArray alloc] init];
    for (NSDictionary *u in unitsFromDictionary) {
        UnitInfoShort *tempUIS = [[UnitInfoShort alloc] init];
        tempUIS.unitId = [u objectForKey:@"unitId"];
        
        [units addObject:tempUIS];
    }
    homeInfo.units = units;
    
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

+ (NSArray *)postListFromJSON:(NSData *)objectNotation gdCategory:(int *)category error:(NSError **)error {
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
    
    int categoryHere = [(NSNumber *)[parsed objectForKey:@"category"] intValue];
    *category = categoryHere;
    
    NSDateFormatter *dateFormatter = [GDInfoBuilder dateFormatter];
    
    NSArray *unitsDictionary = [parsed objectForKey:@"posts"];
    NSMutableArray *posts = [[NSMutableArray alloc] init];

    for (NSDictionary *d in unitsDictionary) {
        PostInfo *post = [[PostInfo alloc] init];
        post.postId = [(NSNumber *)[d objectForKey:@"postId"] intValue];
        post.title = [d objectForKey:@"title"];
        post.gdPostCategory = [(NSNumber *)[d objectForKey:@"gdPostCategory"] intValue];
        post.created = [dateFormatter dateFromString:(NSString *)[d objectForKey:@"created"]];
        
        [posts addObject:post];
    }
    
    return posts;
}

+ (NSArray *)videoListFromJSON:(NSData *)objectNotation gdCategory:(int *)category error:(NSError **)error {
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
    
    int categoryHere = [(NSNumber *)[parsed objectForKey:@"category"] intValue];
    *category = categoryHere;
    
    NSDateFormatter *dateFormatter = [GDInfoBuilder dateFormatter];
    
    NSArray *unitsDictionary = [parsed objectForKey:@"posts"];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    for (NSDictionary *d in unitsDictionary) {
        VideoListItem *tempVli = [[VideoListItem alloc] init];
        tempVli.title = [d objectForKey:@"title"];
        tempVli.title2 = [d objectForKey:@"title2"];
        tempVli.imageURL = [d objectForKey:@"imageURL"];
        tempVli.gdPostCategory = [(NSNumber *)[d objectForKey:@"gdPostCategory"] intValue];
        tempVli.postId = [(NSNumber *)[d objectForKey:@"postId"] intValue];
        tempVli.created = [dateFormatter dateFromString:(NSString *)[d objectForKey:@"created"]];
        
        [posts addObject:tempVli];
    }
    
    return posts;
}

+ (UnitInfo *)unitInfoFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *tempError = nil;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                           options:0
                                                             error: &tempError];
    
    if (tempError) {
        *error = tempError;
        return nil;
    }

    UnitInfo *unit = [[UnitInfo alloc] init];

    for(NSString *key in parsed.allKeys) {
        unichar firstChar = [key characterAtIndex:0];
        NSString *firstLetter = [NSString stringWithCharacters:&firstChar length:1];
        // NSString *keyForSelector = [NSString stringWithFormat:@"set%@%@", [firstLetter uppercaseString], [key substringFromIndex:1]];
        NSString *keyForSelector = [NSString stringWithFormat:@"%@", key];
        
        id val = [parsed objectForKey:key];
        if ([unit respondsToSelector:NSSelectorFromString(keyForSelector)]) {
            [unit setValue:val forKey:key];
        } else {
            NSLog(@"Missing: %@", key);
        }
        
    }

    return unit;
}

@end