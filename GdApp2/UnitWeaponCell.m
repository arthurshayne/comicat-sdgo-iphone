//
//  UnitWeaponCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitWeaponCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Utility.h"

@interface UnitWeaponCell()

@end

@implementation UnitWeaponCell

const CGFloat WEAPON_TEXT_WIDTH = 280;
const CGFloat WEAPON_CELL_PADDING = 8;
const NSString *WEAPON_PE_NONE = @"无";

+ (NSParagraphStyle *)wrapPS {
    static NSMutableParagraphStyle *wrapPS = nil;
    if (!wrapPS) {
        wrapPS = [[NSMutableParagraphStyle alloc] init];
        wrapPS.lineBreakMode = NSLineBreakByWordWrapping;
        wrapPS.paragraphSpacing = 3;
    }
    return wrapPS;
}

- (void)setWeaponId:(uint)weaponId {
    _weaponId = weaponId;
    NSURL *weaponImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.sdgundam.cn/data-source/acc/weapon/%d.gif", _weaponId]];
    
    [[SDWebImageManager sharedManager] downloadWithURL:weaponImageURL
                                               options:0
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                  // progression tracking code
                                              }
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (image && finished) {
                                                     weaponImage = image;
                                                     [self setNeedsDisplay]; // InRect:CGRectMake(0, 0, 150, 84)];
                                                 }
                                             }
     ];
}


- (void)updateWeaponText {
    weaponText = nil;
    weaponText = [[NSMutableAttributedString alloc] init];
    weaponText = [[self class] assembleWeaponInfo:self.weaponIndex
                                       weaponName:self.weaponName
                                     weaponEffect:self.weaponEffect
                                   weaponProperty:self.weaponProperty
                                      weaponRange:self.weaponRange
                                    weaponExLine1:self.weaponExLine1
                                    weaponExLine2:self.weaponExLine2];
}

+ (NSAttributedString *)assembleWeaponInfo:(uint)weaponIndex
                                weaponName:(NSString *)weaponName
                              weaponEffect:(NSString *)weaponEffect
                            weaponProperty:(NSString *)weaponProperty
                               weaponRange:(NSString *)weaponRange
                             weaponExLine1:(NSString *)weaponExLine1
                             weaponExLine2:(NSString *)weaponExLine2 {
    NSMutableAttributedString *weaponText = [[NSMutableAttributedString alloc] init];
    
    NSString *weaponCaption;
    if (weaponIndex > 3) {
        weaponCaption = [NSString stringWithFormat:@"R后 武器%d", weaponIndex - 3];
    } else {
        weaponCaption = [NSString stringWithFormat:@"武器%d", weaponIndex];
    }
    
    NSAttributedString *weaponCaptionAttrStr =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", weaponCaption]
                                        attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                                      NSForegroundColorAttributeName:[Utility UIColorFromRGB:0x005BB6],
                                                      NSParagraphStyleAttributeName:[[self class] wrapPS] }];
    [weaponText appendAttributedString:weaponCaptionAttrStr];
    
    if (![WEAPON_PE_NONE isEqualToString:weaponProperty]) {
        NSAttributedString *weaponPropertyAttrStr =
            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", weaponProperty]
                                            attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                          NSForegroundColorAttributeName:[Utility UIColorFromRGB:0x40C45E]}];
        [weaponText appendAttributedString:weaponPropertyAttrStr];
    }
    
    if (![WEAPON_PE_NONE isEqualToString:weaponEffect]) {
        NSAttributedString *weaponEffectAttrStr =
            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", weaponEffect]
                                            attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                          NSForegroundColorAttributeName:[Utility UIColorFromRGB:0xFFAB54]}];
        [weaponText appendAttributedString:weaponEffectAttrStr];
    }
    
    NSAttributedString *weaponNameAttrStr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", weaponName]
                                    attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                  NSForegroundColorAttributeName:[UIColor blackColor],
                                                  NSParagraphStyleAttributeName:[[self class] wrapPS]}];
    [weaponText appendAttributedString:weaponNameAttrStr];

    if (weaponExLine1) {
        NSAttributedString *weaponLine1AttrStr =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", weaponExLine1]
                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                      NSForegroundColorAttributeName:[Utility UIColorFromRGB:0x02A49C],
                                                      NSParagraphStyleAttributeName:[[self class] wrapPS]}];
        [weaponText appendAttributedString:weaponLine1AttrStr];
    }
    
    NSAttributedString *weaponLine2AttrStr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", weaponExLine2]
                                    attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                  NSForegroundColorAttributeName:[Utility UIColorFromRGB:0x02A49C],
                                                  NSParagraphStyleAttributeName:[[self class] wrapPS]}];
    [weaponText appendAttributedString:weaponLine2AttrStr];
    
    return weaponText;
}

+ (CGFloat)calculateCellHeightFor:(uint)weaponIndex
                       weaponName:(NSString *)weaponName
                     weaponEffect:(NSString *)weaponEffect
                   weaponProperty:(NSString *)weaponProperty
                      weaponRange:(NSString *)weaponRange
                    weaponExLine1:(NSString *)weaponExLine1
                    weaponExLine2:(NSString *)weaponExLine2 {
    
    NSAttributedString *attrString = [[self class]assembleWeaponInfo:weaponIndex
                                                          weaponName:weaponName
                                                        weaponEffect:weaponEffect
                                                      weaponProperty:weaponProperty
                                                         weaponRange:weaponRange
                                                       weaponExLine1:weaponExLine1
                                                       weaponExLine2:weaponExLine2];
    
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(WEAPON_TEXT_WIDTH, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           context:nil];
    return rect.size.height + WEAPON_CELL_PADDING * 2;
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
    
    CGRect imageRect = CGRectMake(226, WEAPON_CELL_PADDING, 84, 27);
    if (weaponImage) {
        [weaponImage drawInRect:imageRect];
    }
    
    if (weaponText) {
        [weaponText drawInRect:CGRectMake(19, WEAPON_CELL_PADDING, WEAPON_TEXT_WIDTH, CGFLOAT_MAX)];
    }
}


@end
