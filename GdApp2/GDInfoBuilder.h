//
//  GDInfoBuilder.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeInfo.h"
#import "PostInfo.h"
#import "UnitInfo.h"
#import "UnitList.h"
#import "GDHasNewOriginResult.h"

@interface GDInfoBuilder : NSObject
+ (HomeInfo *) homeInfoFromJSON: (NSData *)objectNotation error:(NSError **)error;
+ (PostInfo *) postInfoFromJSON: (NSData *)objectNotation error:(NSError **)error;
+ (UnitList *) unitListFromJSON: (NSData *)objectNotation error:(NSError **)error;
+ (NSArray *)postListFromJSON:(NSData *)objectNotation gdCategory:(int *)category error:(NSError **)error;
+ (NSArray *)videoListFromJSON:(NSData *)objectNotation gdCategory:(int *)category error:(NSError **)error;
+ (UnitInfo *)unitInfoFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (GDHasNewOriginResult *)hasNewOriginResultFromJSON:(NSData *)objectNotation error:(NSError **)error;
@end
