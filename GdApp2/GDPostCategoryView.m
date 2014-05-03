//
//  GDPostCategoryView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/3/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostCategoryView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface GDPostCategoryView()

@property (strong, nonatomic) UILabel *categoryTextLabel;

@end

@implementation GDPostCategoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.categoryTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        
        self.categoryTextLabel.backgroundColor = [UIColor clearColor];
        self.categoryTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.categoryTextLabel.font = [UIFont systemFontOfSize:10];
        self.categoryTextLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.categoryTextLabel];
    }
    return self;
}

- (void) setGdPostCategory:(int)gdPostCategory {
    _gdPostCategory = gdPostCategory;
    
    [self.layer addSublayer:[self getGdPostCategoryBackground:gdPostCategory]];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    self.categoryTextLabel.text = [self getGdPostCategoryText:gdPostCategory];
    self.categoryTextLabel.textColor = [UIColor whiteColor];
    
    [self bringSubviewToFront:self.categoryTextLabel];
}

- (NSString *) getGdPostCategoryText:(int)gdPostCategory {
    // TODO: Need for i18n
    switch (gdPostCategory) {
        case 1:
            return @"公告";
        case 2:
            return @"任务";
        case 4:
            return @"机体";
        case 8:
            return @"经验";
        case 16:
            return @"国服";
        case 32:
            return @"韩服";
        case 64:
            return @"台服";
        case 128:
            return @"日服";
        case 256:
            return @"港服";
        case 512:
            return @"美服";
        case 1024:
            return @"泰服";
        case 2048:
            return @"海服";
    }
    return @"";
}

- (CAGradientLayer *) getGdPostCategoryBackground:(int)gdPostCategory {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    NSArray *colors;
    switch (gdPostCategory) {
        case 1:
            // 公告
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x6F96C1).CGColor, (id)UIColorFromRGB(0x2F5587).CGColor, nil];
            break;
        case 2:
            // 任务
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0xFEFEFE).CGColor, (id)UIColorFromRGB(0xC6C6C6).CGColor, nil];
            break;
        case 4:
            // 机体
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0xC3B150).CGColor, (id)UIColorFromRGB(0x7F6C20).CGColor, nil];
            break;
        case 8:
            // 经验
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x7259C3).CGColor, (id)UIColorFromRGB(0x391A8F).CGColor, nil];
            break;
        case 16:
            // 国服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x72BB7F).CGColor, (id)UIColorFromRGB(0x368142).CGColor, nil];
            break;
        case 32:
            // 韩服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x505050).CGColor, (id)UIColorFromRGB(0x262626).CGColor, nil];
            break;
        case 64:
            // 台服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0xE488B3).CGColor, (id)UIColorFromRGB(0xDB6195).CGColor, nil];
            break;
        case 128:
            // 日服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x63C3C0).CGColor, (id)UIColorFromRGB(0x368986).CGColor, nil];
            break;
        case 256:
            // 港服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0xB765A6).CGColor, (id)UIColorFromRGB(0xB765A6).CGColor, nil];
            break;
        case 512:
            // 美服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x364A7C).CGColor, (id)UIColorFromRGB(0x172345).CGColor, nil];
            break;
        case 1024:
            // 泰服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x806B35).CGColor, (id)UIColorFromRGB(0x443713).CGColor, nil];
            break;
        case 2048:
            // 海服
            colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x505050).CGColor, (id)UIColorFromRGB(0x262626).CGColor, nil];
            break;
    }
    
    if (colors) {
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0, 30, 15);
        gradient.startPoint = CGPointMake(0.5, 0.0);
        gradient.endPoint = CGPointMake(0.5, 1.0);
        
        return gradient;
    } else {
        return nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
