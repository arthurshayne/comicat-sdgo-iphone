//
//  GlowingLogoView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/15/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GlowingLogoView.h"

@interface GlowingLogoView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *glowingLogoImageView;

@end

@implementation GlowingLogoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.glowingLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.logoImageView.image = [UIImage imageNamed:@"logo2"];
        self.glowingLogoImageView.image = [UIImage imageNamed:@"logo-glow"];
        self.glowingLogoImageView.hidden = YES;
        
        [self addSubview:self.logoImageView];
        [self addSubview:self.glowingLogoImageView];
    }
    return self;
}

- (void)setGlowing:(BOOL)glowing {
    if (glowing) {
        
        self.glowingLogoImageView.alpha = 0;
        self.glowingLogoImageView.hidden = NO;
        
        [UIView animateWithDuration:1.3
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.glowingLogoImageView.alpha = 1;
                         } completion:^(BOOL finished) {
                             
                         }];
        
    } else {
        self.glowingLogoImageView.hidden = YES;
    }
}


@end
