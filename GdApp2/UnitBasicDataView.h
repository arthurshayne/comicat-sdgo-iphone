//
//  UnitBasicDataView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitBasicDataView : UIView

@property (strong, nonatomic) NSString *unitId;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *rank;

@property (nonatomic) float attackValue;
@property (nonatomic) float defenseValue;
@property (nonatomic) float mobilityValue;
@property (nonatomic) float controlValue;

@property (nonatomic) float sum3DValue;
@property (nonatomic) float sum4DValue;

- (void)playAnimations;

@end
