//
//  GeneralService.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/14/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GeneralService.h"
#import <LevelDB.h>

@implementation GeneralService

+ (LevelDB *)ldbInstance {
    static LevelDB *sharedLDBInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLDBInstance = [LevelDB databaseInLibraryWithName:@"GeneralService.ldb"];
    });
    return sharedLDBInstance;
}

static NSString *UnitViewedForEasterEggPrefix = @"UNIT_VIEWED_EG_%@";

+ (void)markUnitViewedForEasterEgg:(NSString *)unitId {
    [[[self class] ldbInstance]
        setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:UnitViewedForEasterEggPrefix, unitId]];
}

+ (BOOL)isUnitViewedForEasterEgg:(NSString *)unitId {
    return [(NSNumber *)[[[self class] ldbInstance] objectForKey:[NSString stringWithFormat:UnitViewedForEasterEggPrefix, unitId]] boolValue];
}

+ (void)clearEaterEggUnitViews {
    [[[self class] ldbInstance] removeAllObjectsWithPrefix:[NSString stringWithFormat:UnitViewedForEasterEggPrefix, @""]];
}

+ (void)setObject:(id)value forKey:(NSString *)key {
    [[[self class] ldbInstance] setObject:value forKey:key];
}

+ (void)removeObjectForKey:(NSString *)key {
    [[[self class] ldbInstance] removeObjectForKey:key];
}

+ (BOOL)readBooleanForKey:(NSString *)key {
    return [(NSNumber *)[[[self class] ldbInstance] objectForKey:key] boolValue];
}

@end
