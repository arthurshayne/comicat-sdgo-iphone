//
//  UnitInfoShort.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/8/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoCoding.h"

@interface UnitInfoShort : NSObject
@property (strong, nonatomic) NSString *unitId;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *rank;
@property (strong, nonatomic) NSString *warType;
@property int origin;
@property (strong, nonatomic) NSString *originTitleShort;
@property float rating;

@end
