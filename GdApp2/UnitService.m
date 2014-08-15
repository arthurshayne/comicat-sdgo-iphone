//
//  UnitService.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/14/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitService.h"
#import <LevelDB.h>

@implementation UnitService

+ (LevelDB *)ldbInstance {
    static LevelDB *sharedLDBInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLDBInstance = [LevelDB databaseInLibraryWithName:@"UnitService.ldb"];
    });
    return sharedLDBInstance;
}

static NSString *UnitViewedPrefix = @"UNIT_VIEWED_%@";

+ (void)markUnitViewed:(NSString *)unitId {
    [[[self class] ldbInstance]
        setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:UnitViewedPrefix, unitId]];
}

+ (BOOL)isUnitViewed:(NSString *)unitId {
    return [(NSNumber *)[[[self class] ldbInstance] objectForKey:[NSString stringWithFormat:UnitViewedPrefix, unitId]] boolValue];
}

+ (BOOL)areUnitsAllViewed:(NSArray *)unitIds {
    BOOL viewed = YES;
    
    for (NSString *unitId in unitIds) {
        viewed = viewed && [[self class] isUnitViewed:unitId];
    }
    
    return viewed;
}

@end
