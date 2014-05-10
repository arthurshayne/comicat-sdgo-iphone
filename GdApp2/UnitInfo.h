//
//  UnitInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/7/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitInfo : NSObject
@property int unitId;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *rank;
@property (strong, nonatomic) NSString *warType;
@property (strong, nonatomic) NSString *landForm;
@property int origin;
@property (strong, nonatomic) NSString *originTitle;
@property (strong, nonatomic) NSString *story;

@end
