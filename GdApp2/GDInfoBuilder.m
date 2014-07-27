//
//  GDInfoBuilder.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "objc/runtime.h"

#import "GDInfoBuilder.h"
#import "HomeInfo.h"
#import "CarouselInfo.h"
#import "VideoListItem.h"
#import "PostInfo.h"
#import "UnitInfoShort.h"
#import "UnitInfo.h"
#import "GDHasNewOriginResult.h"
#import "OriginInfo.h"

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
    
    // homeInfo.success = [(NSNumber *)[parsed objectForKey:@"success"] boolValue];
    
    NSDateFormatter *dateFormatter = [[[self class] dateFormatter] copy];
    
    homeInfo.generated = [[[self class] dateFormatter] dateFromString:(NSString *)[parsed objectForKey:@"generated"]];
    
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
    
    NSDateFormatter *dateFormatter = [[[self class] dateFormatter] copy];

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
    post.userName = [parsed objectForKey:@"createdBy"];
    post.authorId = [(NSNumber *)[parsed objectForKey:@"authorId"] intValue];
    post.briefText = [parsed objectForKey:@"briefText"];
    post.clicks = [(NSNumber *)[parsed objectForKey:@"clicks"] intValue];
    
    return post;
}

+ (UnitList *)unitListFromJSON:(NSData *)objectNotation error:(NSError **)error {
    // returns Array of UnitInfoShort
    NSError *tempError = nil;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                           options:0
                                                             error: &tempError];
    if (tempError) {
        *error = tempError;
        return nil;
    }

    UnitList *list = [[UnitList alloc] init];
    
    list.generated = [[[self class] dateFormatter] dateFromString:(NSString *)[parsed objectForKey:@"generated"]];
    
    list.origin = [parsed objectForKey:@"origin"];
    list.searchKeyword = [parsed objectForKey:@"keyword"];
    
    NSArray *unitsArray = [parsed objectForKey:@"units"];
    NSMutableArray *units = [[NSMutableArray alloc] init];
    for (NSDictionary *d in unitsArray) {
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
    list.units = units;
    
    return list;
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
    
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    
    int categoryHere = [(NSNumber *)[parsed objectForKey:@"category"] intValue];
    *category = categoryHere;
    
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
    
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    
    int categoryHere = [(NSNumber *)[parsed objectForKey:@"category"] intValue];
    *category = categoryHere;
    
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

+ (UnitMixMaterial *)extractKeyUMM:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    UnitMixMaterial *umm = [[UnitMixMaterial alloc] init];
    
    umm.unitId = [dict objectForKey:@"unitId"];
    umm.modelName = [dict objectForKey:@"modelName"];
    umm.level = [dict objectForKey:@"level"];
    
    return umm;
}

+ (NSArray *)extractOtherUMMs:(NSArray *)array {
    if (!array || array.count == 0) {
        return [NSArray arrayWithObjects: nil];
    }
    NSMutableArray *otherUMMs = [[NSMutableArray alloc] init];
    for (NSDictionary *d in array) {
        [otherUMMs addObject:[[self class] extractKeyUMM:d]];
    }
    return otherUMMs;
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
    
    
    NSDictionary *unitInfoFromJSON = [parsed objectForKey:@"unit"];
    UnitInfo *unit = [[UnitInfo alloc] init];

    for(NSString *key in unitInfoFromJSON.allKeys) {
//        unichar firstChar = [key characterAtIndex:0];
//        NSString *firstLetter = [NSString stringWithCharacters:&firstChar length:1];
        // NSString *keyForSelector = [NSString stringWithFormat:@"set%@%@", [firstLetter uppercaseString], [key substringFromIndex:1]];
        NSString *keyForSelector = [NSString stringWithFormat:@"%@", key];
        
        objc_property_t property = class_getProperty([UnitInfo class], [keyForSelector UTF8String]);
        if (property != NULL) {
            const char *propertyAttributes = property_getAttributes(property);
            // check if readonly property
            if (![[[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","] containsObject:@"R"]) {
                id val = [unitInfoFromJSON objectForKey:key];
                if ([unit respondsToSelector:NSSelectorFromString(keyForSelector) ]) {
                    [unit setValue:val forKey:key];
                } else {
                    // NSLog(@"Missing: %@", key);
                }
            } else {
                // NSLog(@"Readonly: %@", key);
            }
        }
    }
    
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    
    NSArray *videoListFromJSON = [parsed objectForKey:@"videoList"];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    for (NSDictionary *d in videoListFromJSON) {
        VideoListItem *tempVli = [[VideoListItem alloc] init];
        tempVli.title = [d objectForKey:@"title"];
        tempVli.title2 = [d objectForKey:@"title2"];
        tempVli.imageURL = [d objectForKey:@"imageURL"];
        tempVli.gdPostCategory = [(NSNumber *)[d objectForKey:@"gdPostCategory"] intValue];
        tempVli.postId = [(NSNumber *)[d objectForKey:@"postId"] intValue];
        tempVli.created = [dateFormatter dateFromString:(NSString *)[d objectForKey:@"created"]];
        
        [posts addObject:tempVli];
    }
    unit.videoList = posts;
    
    // mixing
//    NSDictionary *mixing = [parsed objectForKey:@"mixing"];
//    
//    NSDictionary *mixingG = [mixing objectForKey:@"_G"];
//    unit.mixingKeyUnit = [[self class] extractKeyUMM:[mixingG objectForKey:@"keyUnit"]];
//    unit.mixingMaterialUnits = [[self class] extractOtherUMMs:[mixingG objectForKey:@"materialUnits"]];
//    
//    NSDictionary *mixingCN = [mixing objectForKey:@"CN"];
//    unit.mixingKeyUnitCN = [[self class] extractKeyUMM:[mixingCN objectForKey:@"keyUnit"]];
//    unit.mixingMaterialUnitsCN = [[self class] extractOtherUMMs:[mixingCN objectForKey:@"materialUnits"]];
//    
//    unit.canMixAsKey = [[self class] extractOtherUMMs:[mixing objectForKey:@"canMixAsKey"]];
//    unit.canMixAsMaterial = [[self class] extractOtherUMMs:[mixing objectForKey:@"canMixAsMaterial"]];
//    
    return unit;
}

+ (GDHasNewOriginResult *)hasNewOriginResultFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *tempError = nil;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                           options:0
                                                             error: &tempError];
    
    if (tempError) {
        *error = tempError;
        return nil;
    }
    
    GDHasNewOriginResult *result = [[GDHasNewOriginResult alloc] init];
    
    result.result = [(NSNumber *)[parsed objectForKey:@"result"] boolValue];
    
    NSArray *originsFromJSON = (NSArray *)[parsed objectForKey:@"origins"];
    
    if (originsFromJSON) {
        NSMutableArray *origins = [[NSMutableArray alloc] init];
        for (NSDictionary *d in originsFromJSON) {
            OriginInfo *oi = [[OriginInfo alloc] init];
            oi.originIndex = [d objectForKey:@"origin"];
            oi.title = [d objectForKey:@"title"];
            oi.shortTitle = [d objectForKey:@"shortTitle"];
            oi.numberOfUnits = [(NSNumber *)[d objectForKey:@"units"] unsignedIntValue];
            oi.displayOrder = [(NSNumber *)[d objectForKey:@"displayOrder"] unsignedIntValue];
            
            [origins addObject:oi];
        }
        
        result.origins = origins;
    }
    
    return result;
}

@end