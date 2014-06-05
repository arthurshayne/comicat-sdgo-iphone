//
//  UnitGaugeBarView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UnitGaugeType) {
    UnitGaugeTypeAttack     = 1,
    UnitGaugeTypeDefense    = 2,
    UnitGaugeTypeMobility   = 3,
    UnitGaugeTypeControl    = 4
};

@interface UnitGaugeBarView : UIView

@property (strong, nonatomic) NSString *textOnGauge;
@property (nonatomic) UnitGaugeType gaugeType;
@property (nonatomic) float gaugePercent;

- (id)initWithFrame:(CGRect)frame andGaugeType:(UnitGaugeType)gaugeType;
- (void)playAnimation;

@end
