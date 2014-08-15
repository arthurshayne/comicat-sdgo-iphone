//
//  UnitMixMaterialView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/31/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitMixMaterialView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UnitMixMaterialView()

@property (strong, nonatomic) UIImageView *unitImageView;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UILabel *keyUnitLabel;

@end

@implementation UnitMixMaterialView

- (UIImageView *)unitImageView {
    if (!_unitImageView) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-4, 19, self.frame.size.width + 8, self.frame.size.width + 8)];

        CAGradientLayer *borderLayer = [CAGradientLayer layer];
        borderLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        borderLayer.borderColor = [UIColor colorWithRed:195/255 green:195/255 blue:195/255 alpha:0.18].CGColor;
        borderLayer.borderWidth = 1;
        borderLayer.colors = [NSArray arrayWithObjects:
                                (id)[[GDAppUtility UIColorFromRGB:0xD0D8E5] CGColor],
                                (id)[[GDAppUtility UIColorFromRGB:0xE2EAF7] CGColor], nil];
        borderLayer.startPoint = CGPointMake(0.5, 1);
        borderLayer.endPoint = CGPointMake(0.5, 0);
        
        [bgView.layer addSublayer:borderLayer];
        
        _unitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width, self.frame.size.width)];
        
        [bgView addSubview:_unitImageView];
        
        [self addSubview:bgView];
    }
    return _unitImageView;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(-4, 25 + self.frame.size.width, 8 + self.frame.size.width, 15)];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = [UIFont systemFontOfSize:12];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.backgroundColor = [GDAppUtility UIColorFromRGB:0x5A79A1];
        
        [self addSubview:_levelLabel];
    }
    return _levelLabel;
}

- (UILabel *)keyUnitLabel {
    if (!_keyUnitLabel) {
        _keyUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(-4, 4, self.frame.size.width, 15)];
        _keyUnitLabel.numberOfLines = 1;
        _keyUnitLabel.text = @" 核心机 ";
        _keyUnitLabel.font = [UIFont systemFontOfSize:12];
        _keyUnitLabel.textColor = [UIColor whiteColor];
        _keyUnitLabel.backgroundColor = [GDAppUtility UIColorFromRGB:0x5A79A1];
        [_keyUnitLabel sizeToFit];
        
        [self addSubview:_keyUnitLabel];
    }
    return _keyUnitLabel;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUmm:(UnitMixMaterial *)umm {
    _umm = umm;
    
    [self.unitImageView sd_setImageWithURL:[GDAppUtility URLForUnitImageOfUnitId:umm.unitId]
                       placeholderImage:[UIImage imageNamed:@"placeholder-unit"]];
    self.levelLabel.text = umm.level;
}

- (void)setIsKeyUnit:(BOOL)isKeyUnit {
    _isKeyUnit = isKeyUnit;
    
    self.keyUnitLabel.hidden = !_isKeyUnit;
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    
//}


@end
