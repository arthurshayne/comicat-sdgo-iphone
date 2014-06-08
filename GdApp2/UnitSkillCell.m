//
//  UnitSkillCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitSkillCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Utility.h"

@interface UnitSkillCell()

@property (strong, nonatomic) UIImage *skillImage;

@end

@implementation UnitSkillCell

const CGFloat SKILL_TEXT_WIDTH = 233;
const CGFloat SKILL_CELL_PADDING = 8;

+ (NSParagraphStyle *)wrapPS {
    static NSMutableParagraphStyle *wrapPS = nil;
    if (!wrapPS) {
        wrapPS = [[NSMutableParagraphStyle alloc] init];
        wrapPS.lineBreakMode = NSLineBreakByWordWrapping;
        wrapPS.paragraphSpacing = 3;
    }
    return wrapPS;
}


- (void)setSkillId:(uint)skillId {
    _skillId = skillId;
    NSURL *skillImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.sdgundam.cn/data-source/acc/skill/%d.gif", _skillId]];
    
    [[SDWebImageManager sharedManager] downloadWithURL:skillImageURL
                                               options:0
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                  // progression tracking code
                                              }
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (image && finished) {
                                                     self.skillImage = image;
                                                     [self setNeedsDisplay]; // InRect:CGRectMake(0, 0, 150, 84)];
                                                 }
                                             }
     ];
}

- (void)updateSkillText {
    skillText = nil;
    skillText = [[NSMutableAttributedString alloc] init];
    skillText = [[self class] assembleSkillInfo:self.skillName skillDesc:self.skillDesc skillEx:self.skillEx];
}

+ (NSAttributedString *)assembleSkillInfo:(NSString *)skillName skillDesc:(NSString *)skillDesc skillEx:(NSString *)skillEx {
    NSMutableAttributedString *skillText = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *skillNameAttrStr =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", skillName]
                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                      NSForegroundColorAttributeName:[Utility UIColorFromRGB:0x005BB6],
                                                      NSParagraphStyleAttributeName: [self.class wrapPS] }];
    NSAttributedString *skillDescAttrStr =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", skillDesc]
                                        attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:13],
                                                      NSForegroundColorAttributeName: [UIColor blackColor],
                                                      NSParagraphStyleAttributeName: [self.class wrapPS] }];
    
    NSAttributedString *skillExAttrStr =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", skillEx]
                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                      NSForegroundColorAttributeName:[Utility UIColorFromRGB:0x98121D] }];
    
    [skillText appendAttributedString:skillNameAttrStr];
    [skillText appendAttributedString:skillDescAttrStr];
    [skillText appendAttributedString:skillExAttrStr];
    
    return skillText;
}

+ (CGFloat)calculateCellHeightForSkillName:(NSString *)skillName skillDesc:(NSString *)skillDesc skillEx:(NSString *)skillEx {
    NSAttributedString *attrString = [[self class]assembleSkillInfo:skillName skillDesc:skillDesc skillEx:skillEx];
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(SKILL_TEXT_WIDTH, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           context:nil];
    return rect.size.height + SKILL_CELL_PADDING * 2;
}

- (void)layoutSubviews
{
	CGRect b = [self bounds];
	[contentView setFrame:b];
    [super layoutSubviews];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(ctx, r);

    CGRect imageRect = CGRectMake(19, SKILL_CELL_PADDING, 36, 36);
    if (self.skillImage) {
        [self.skillImage drawInRect:imageRect];
    }
    
    if (skillText) {
        [skillText drawInRect:CGRectMake(65, SKILL_CELL_PADDING, SKILL_TEXT_WIDTH, CGFLOAT_MAX)];
    }
}

@end
