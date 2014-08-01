//
//  UnitMixView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitMixPopupView.h"
#import "UnitMixMaterialView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface UnitMixPopupView ()

@property (strong, nonatomic) UILabel *captionLabel;

@property (strong, nonatomic) UILabel *modelNameLabel;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIImageView *keyUnitImageView;
@property (strong, nonatomic) UILabel *keyUnitLvLabel;

@property (strong, nonatomic) NSArray *matUnitImageViews;   // of UIImageView
@property (strong, nonatomic) NSArray *matUnitLvLabels;   // of UILabel

@property (strong, nonatomic) UITableView *units;

@end

@implementation UnitMixPopupView

+ (NSArray *)layoutFor3 {
    static NSArray *rectsFor3;
    if (!rectsFor3) {
        rectsFor3 = [NSArray arrayWithObjects:
                       [NSValue valueWithCGRect:CGRectMake(20, 38, 79, 109)],
                       [NSValue valueWithCGRect:CGRectMake(118.5, 38, 79, 109)],
                       [NSValue valueWithCGRect:CGRectMake(219, 38, 79, 109)], nil];
    }
    return rectsFor3;
}

+ (NSArray *)layoutFor4 {
    static NSArray *rectsFor4;
    if (!rectsFor4) {
        rectsFor4 = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(8, 38, 65, 109)],
                     [NSValue valueWithCGRect:CGRectMake(87, 38, 65, 109)],
                     [NSValue valueWithCGRect:CGRectMake(166, 38, 65, 109)],
                     [NSValue valueWithCGRect:CGRectMake(245, 38, 65, 109)], nil];
    }
    return rectsFor4;
}

+ (NSArray *)layoutFor5 {
    static NSArray *rectsFor5;
    if (!rectsFor5) {
        rectsFor5 = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(72, 38, 71, 109)],
                     [NSValue valueWithCGRect:CGRectMake(169, 38, 71, 109)],
                     [NSValue valueWithCGRect:CGRectMake(31.5, 140, 71, 100)],
                     [NSValue valueWithCGRect:CGRectMake(120.5, 140, 71, 100)],
                     [NSValue valueWithCGRect:CGRectMake(209.5, 140, 71, 100)], nil];
    }
    return rectsFor5;
}

- (UILabel *)captionLabel {
    if (!_captionLabel) {
        _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, 26)];
        _captionLabel.font = [UIFont systemFontOfSize:14];
        _captionLabel.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:250.0/255 alpha:0.87];
        _captionLabel.textColor = [UIColor blackColor];
        _captionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_captionLabel];
        
        UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        topBorder.backgroundColor = [GDAppUtility appTintColor];
        [self addSubview:topBorder];
    }
    return _captionLabel;
}

- (void)setCaption:(NSString *)caption {
    _caption = caption;
    
    self.captionLabel.text = caption;
}

- (id) initWithKeyUnit:(UnitMixMaterial *)keyUnit
           materialUnits:(NSArray *)materialUnits {
    
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           [[UIScreen mainScreen]bounds].size.width,
                                           materialUnits.count == 4 ? 258 : 170)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        NSArray *usingLayout;
        // decide which layout to use
        if (materialUnits.count == 2) {
            usingLayout = [[self class] layoutFor3];
        } else if (materialUnits.count == 3) {
            usingLayout = [[self class] layoutFor4];
        } else if (materialUnits.count == 4) {
            usingLayout = [[self class] layoutFor5];
        }

        // key unit
        [self renderUMM:keyUnit isKeyUnit:YES inCGRect:[[usingLayout objectAtIndex:0] CGRectValue]];
        
        // materials
        for (int i = 0; i < materialUnits.count; i++) {
            UnitMixMaterial *umm = [materialUnits objectAtIndex:i];
            
            [self renderUMM:umm isKeyUnit:NO inCGRect:[[usingLayout objectAtIndex:i + 1] CGRectValue]];
        }
    }
    return self;
}

- (void)renderUMM:(UnitMixMaterial *)umm
        isKeyUnit:(BOOL)isKeyUnit
         inCGRect:(CGRect)frame {

    UnitMixMaterialView *ummv = [[UnitMixMaterialView alloc] initWithFrame:frame];
    ummv.umm = umm;
    ummv.isKeyUnit = isKeyUnit;
    
    ummv.userInteractionEnabled = YES;
    
    [self addSubview:ummv];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [ummv addGestureRecognizer:tap];
}

- (void)tapOnView:(UITapGestureRecognizer *)recognizer {
    UnitMixMaterialView * ummv = (UnitMixMaterialView *)recognizer.view;
    NSLog(@"Tapped on %@!", ummv.umm.unitId);
    
    if (self.dismissWithClickOnUnit) {
        self.dismissWithClickOnUnit(ummv.umm.unitId);
    }
}


/*
 Popup Views:
 
 https://www.cocoacontrols.com/controls/alpopupview
 https://github.com/evnaz/ENPopUp/tree/master/ENPopUp
 https://github.com/jmascia/KLCPopup
 https://github.com/AlvaroFranco/AFPopupView
 https://github.com/martinjuhasz/MJPopupViewController
 
 
 */

@end
