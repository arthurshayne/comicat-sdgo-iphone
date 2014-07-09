//
//  UnitBasicDataView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitBasicDataView.h"

#import "UnitGaugeBarView.h"
#import "ScrollingTextView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface UnitBasicDataView ()
@property (strong, nonatomic) ScrollingTextView *modelNameLabel;
@property (strong, nonatomic) UILabel *rankLabel;
@property (strong, nonatomic) UIImageView *unitImageView;
@property (strong, nonatomic) UILabel *sum3DLabel;
@property (strong, nonatomic) UILabel *sum4DLabel;

@property (strong, nonatomic) UnitGaugeBarView *attackBar;
@property (strong, nonatomic) UnitGaugeBarView *defenseBar;
@property (strong, nonatomic) UnitGaugeBarView *mobilityBar;
@property (strong, nonatomic) UnitGaugeBarView *controlBar;

@end

@implementation UnitBasicDataView

const float UNIT_MAX_ABILITY_VALUE = 205;

+ (UIFont *)fontForCaptions {
    static UIFont *_fontForCaptions;
    if (!_fontForCaptions) {
        _fontForCaptions = [UIFont systemFontOfSize:14];
    }
    return _fontForCaptions;
}

- (UnitGaugeBarView *)attackBar {
    if (!_attackBar) {
        _attackBar = [[UnitGaugeBarView alloc] initWithFrame:CGRectMake(178, 32, 122, 14) andGaugeType:UnitGaugeTypeAttack];
        [self addSubview:_attackBar];
    }

    return _attackBar;
}

- (UnitGaugeBarView *)defenseBar {
    if (!_defenseBar) {
        _defenseBar = [[UnitGaugeBarView alloc] initWithFrame:CGRectMake(178, 54, 122, 14) andGaugeType:UnitGaugeTypeDefense];
        [self addSubview:_defenseBar];
    }

    return _defenseBar;
}

- (UnitGaugeBarView *)mobilityBar {
    if (!_mobilityBar) {
        _mobilityBar = [[UnitGaugeBarView alloc] initWithFrame:CGRectMake(178, 76, 122, 14) andGaugeType:UnitGaugeTypeMobility];
        [self addSubview:_mobilityBar];
    }

    return _mobilityBar;
}

- (UnitGaugeBarView *)controlBar {
    if (!_controlBar) {
        _controlBar = [[UnitGaugeBarView alloc] initWithFrame:CGRectMake(178, 98, 122, 14) andGaugeType:UnitGaugeTypeControl];
        [self addSubview:_controlBar];
    }

    return _controlBar;
}

- (ScrollingTextView *)modelNameLabel {
    if (!_modelNameLabel) {
        _modelNameLabel = [[ScrollingTextView alloc] initWithFrame:CGRectMake(14, 0, 210, 21)];
        _modelNameLabel.backgroundColor = [UIColor clearColor];
        _modelNameLabel.speed = 0.012;
        [self addSubview:_modelNameLabel];
    }
    return _modelNameLabel;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(223, 0, 42, 21)];
        _rankLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
        _rankLabel.textColor = [GDAppUtility UIColorFromRGB:0x3F6FAD];
        _rankLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rankLabel];
    }
    return _rankLabel;
}

- (UIImageView *)unitImageView {
    if (!_unitImageView) {
        _unitImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 120, 120)];
        _unitImageView.image = [UIImage imageNamed:@"placeholder-unit"];
        _unitImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_unitImageView];
    }
    return _unitImageView;
}

- (UILabel *)sum3DLabel {
    if (!_sum3DLabel) {
        _sum3DLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 118, 42, 21)];
        _sum3DLabel.textColor = [UIColor redColor];
        _sum3DLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_sum3DLabel];
    }
    return _sum3DLabel;
}

- (UILabel *)sum4DLabel {
    if (!_sum4DLabel) {
        _sum4DLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 140, 42, 21)];
        _sum4DLabel.textColor = [UIColor blackColor];
        _sum4DLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_sum4DLabel];
    }
    return _sum4DLabel;
}

- (void)setUnitId:(NSString *)unitId {
    _unitId = unitId;
    [self.unitImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.sdgundam.cn/data-source/acc/unit-yoppa/app/%@.png", unitId]]];
}

- (void)setModelName:(NSString *)modelName {
    _modelName = modelName;
    self.modelNameLabel.text = _modelName;
}

- (void)setRank:(NSString *)rank {
    _rank = rank;
    self.rankLabel.text = _rank;
}

- (void)setAttackValue:(float)attackValue {
    _attackValue = attackValue;
    self.attackBar.gaugePercent = attackValue / UNIT_MAX_ABILITY_VALUE;
    self.attackBar.textOnGauge = [NSString stringWithFormat:@"%d", (int)attackValue];
}

- (void)setDefenseValue:(float)defenseValue {
    _defenseValue = defenseValue;
    self.defenseBar.gaugePercent = defenseValue / UNIT_MAX_ABILITY_VALUE;
    self.defenseBar.textOnGauge = [NSString stringWithFormat:@"%d", (int)defenseValue];
}

- (void)setMobilityValue:(float)mobilityValue {
    _mobilityValue = mobilityValue;
    self.mobilityBar.gaugePercent = mobilityValue / UNIT_MAX_ABILITY_VALUE;
    self.mobilityBar.textOnGauge = [NSString stringWithFormat:@"%d", (int)mobilityValue];
}

- (void)setControlValue:(float)controlValue {
    _controlValue = controlValue;
    self.controlBar.gaugePercent = controlValue / UNIT_MAX_ABILITY_VALUE;
    self.controlBar.textOnGauge = [NSString stringWithFormat:@"%d", (int)controlValue];
}

- (void)setSum3DValue:(float)sum3DValue {
    _sum3DValue = sum3DValue;
    self.sum3DLabel.text = [NSString stringWithFormat:@"%d", (int)sum3DValue];
}

- (void)setSum4DValue:(float)sum4DValue {
    _sum4DValue = sum4DValue;
    self.sum4DLabel.text = [NSString stringWithFormat:@"%d", (int)sum4DValue];
}

- (void)playAnimations {
    [self.attackBar playAnimation];
    [self.defenseBar playAnimation];
    [self.mobilityBar playAnimation];
    [self.controlBar playAnimation];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // put it into view
        self.unitImageView.hidden = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // draw all captions
    NSString *attackCaption = @"攻击";
    [attackCaption drawAtPoint:CGPointMake(138, 30)
                withAttributes:@{ NSFontAttributeName:[self.class fontForCaptions] }];
    
    NSString *defenseCaption = @"防御";
    [defenseCaption drawAtPoint:CGPointMake(138, 52)
                withAttributes:@{ NSFontAttributeName:[self.class fontForCaptions] }];
    
    NSString *mobilityCaption = @"机动";
    [mobilityCaption drawAtPoint:CGPointMake(138, 74)
                withAttributes:@{ NSFontAttributeName:[self.class fontForCaptions] }];
    
    NSString *controlCaption = @"操控";
    [controlCaption drawAtPoint:CGPointMake(138, 96)
                withAttributes:@{ NSFontAttributeName:[self.class fontForCaptions] }];
    
    NSString *sum3DCaption = @"能力(3D)总和";
    [sum3DCaption drawAtPoint:CGPointMake(138, 118)
                 withAttributes:@{ NSFontAttributeName:[self.class fontForCaptions],
                                   NSForegroundColorAttributeName:[UIColor redColor]}];
    
    NSString *sum4DCaption = @"4D总和";
    [sum4DCaption drawAtPoint:CGPointMake(138, 140)
               withAttributes:@{ NSFontAttributeName:[self.class fontForCaptions] }];
    
    NSString *rankCaption = @"rank";
    [rankCaption drawAtPoint:CGPointMake(270, 2.2)
               withAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Verdana-Bold" size:12],
                                 NSForegroundColorAttributeName:[GDAppUtility UIColorFromRGB:0x3F6FAD] }];
}


@end
