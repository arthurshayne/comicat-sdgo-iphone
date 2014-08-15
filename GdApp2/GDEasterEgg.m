//
//  GDEasterEgg.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDEasterEgg.h"
#import "GeneralService.h"

@implementation GDEasterEgg

+ (NSArray *)allDOMUnits {
    static NSArray *_allDOMUnits;
    if (!_allDOMUnits) {
        _allDOMUnits = @[@"15089", @"15085", @"11038", @"11035", @"11034", @"11026", @"11004", @"11023", @"11003"];
    }
    return _allDOMUnits;
}

+ (void)proceedEasterEggDiscovery:(NSString *)unitId {
    if ([[[self class] allDOMUnits] containsObject:unitId]) {
        [GeneralService markUnitViewedForEasterEgg:unitId];
     
        BOOL allViewed = YES;
        for (NSString *unitId in [[self class] allDOMUnits]) {
            allViewed = allViewed && [GeneralService isUnitViewedForEasterEgg:unitId];
        }
        
        if (allViewed) {
            [[self class] turnOnEasterEgg];
        }
    }
}

static NSString *EasterEggEnabledKey = @"EasterEggEnabled";

+ (void)turnOnEasterEgg {
    [GeneralService setObject:[NSNumber numberWithBool:YES] forKey:EasterEggEnabledKey];
}

+ (void)turnOffEasterEgg {
    [GeneralService removeObjectForKey:EasterEggEnabledKey];
    [GeneralService clearEaterEggUnitViews];
}

+ (BOOL)isEasterEggEnabled {
    return [GeneralService readBooleanForKey:EasterEggEnabledKey];
}

@end


/*
 
 
15089
15085
11038
11035
11034
11026
11004
11023
11003

*/