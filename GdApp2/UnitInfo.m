//
//  UnitInfo.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/7/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitInfo.h"

@implementation UnitInfo

- (float)sum3D {
    return self.attackG + self.defenseG + self.mobilityG;
}

- (float)sum4D {
    return self.sum3D + self.controlG;
}

- (uint)numberOfWeapons {
    if (self.weapon4 == 0) {
        return 3;
    } else if (self.weapon5 == 0) {
        return 4;
    } else if (self.weapon6 == 0) {
        return 5;
    } else {
        return 6;
    }
}

- (void)stubFloatSetter:(float)value { }
- (void)stubUIntSetter:(uint)value { }

@end
