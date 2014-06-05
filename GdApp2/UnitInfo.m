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
@end
