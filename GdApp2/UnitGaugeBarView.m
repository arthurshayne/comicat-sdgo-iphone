//
//  UnitGaugeBarView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitGaugeBarView.h"

@interface UnitGaugeBarView ()

@property (strong, nonatomic) UIImageView *gaugeBackground;
@property (strong, nonatomic) UIImageView *gauge;
@property (strong, nonatomic) UILabel *labelOnGauge;

@end

@implementation UnitGaugeBarView

- (UIImageView *) gaugeBackground {
    if (!_gaugeBackground) {
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, 0);
        _gaugeBackground = [[UIImageView alloc] initWithFrame:frame];
        _gaugeBackground.image = [UIImage imageNamed:@"unit-gauge-bg"];
        
        [self addSubview:_gaugeBackground];
    }
    return _gaugeBackground;
}

- (UIImageView *) gauge {
    if (!_gauge) {
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, 0);
        frame.size.width = 1;
        _gauge = [[UIImageView alloc] initWithFrame:frame];
        
        NSString *imageName;
        switch (self.gaugeType) {
            case UnitGaugeTypeAttack:
                imageName = @"unit-gauge-attack";
                break;
            case UnitGaugeTypeDefense:
                imageName = @"unit-gauge-defense";
                break;
            case UnitGaugeTypeMobility:
                imageName = @"unit-gauge-mobility";
                break;
            case UnitGaugeTypeControl:
                imageName = @"unit-gauge-control";
                break;
        }
        _gauge.image = [UIImage imageNamed:imageName];
        
        [self addSubview:_gauge];
    }
    return _gauge;
}

- (UILabel *)labelOnGauge {
    if (!_labelOnGauge) {
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, 0);
        frame.size.width = 20;
        
        _labelOnGauge = [[UILabel alloc] initWithFrame:frame];
        UIFont *font = [UIFont fontWithName:@"Helvetica Neue Bold Italic" size:11];
        _labelOnGauge.font = font;
        _labelOnGauge.textAlignment = NSTextAlignmentRight;
        _labelOnGauge.textColor = [UIColor whiteColor];

        
        [self addSubview:_labelOnGauge];
    }
    return _labelOnGauge;
}

- (id)initWithFrame:(CGRect)frame andGaugeType:(UnitGaugeType)gaugeType {
    self = [super initWithFrame:frame];
    if (self) {
        self.gaugeType = gaugeType;
        
        // activate subviews
        [self gaugeBackground];
        [self gauge];
        [self labelOnGauge];
        
        self.labelOnGauge.alpha = 0;
    }
    return self;
}

- (void)setTextOnGauge:(NSString *)textOnGauge {
    _textOnGauge = textOnGauge;
    self.labelOnGauge.text = _textOnGauge;
}

- (void)playAnimation {
    [UIView animateWithDuration:0.61 delay:0.1 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        CGRect imageFrame = self.gauge.frame;
        imageFrame.size.width = self.frame.size.width * self.gaugePercent;
        self.gauge.frame = imageFrame;
        
        CGRect labelFrame = self.labelOnGauge.frame;
        labelFrame.origin.x = imageFrame.size.width - labelFrame.size.width / 2;
        
        CGPoint labelCenter = self.labelOnGauge.center;
        self.labelOnGauge.center = CGPointMake(imageFrame.size.width - labelFrame.size.width / 2 - 4, labelCenter.y);
        self.labelOnGauge.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
