//
//  UnitMiscInfoCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitMiscInfoCell.h"
#import "UnitInfo.h"

@implementation UnitMiscInfoCell

const CGFloat MISC_TEXT_WIDTH = 280;
const CGFloat MISC_CELL_PADDING = 23;

+ (NSParagraphStyle *)psWide {
    static NSMutableParagraphStyle *wrapPS = nil;
    if (!wrapPS) {
        wrapPS = [[NSMutableParagraphStyle alloc] init];
        wrapPS.lineBreakMode = NSLineBreakByWordWrapping;
        wrapPS.paragraphSpacing = 8;
    }
    return wrapPS;
}

+ (NSParagraphStyle *)psNarrow {
    static NSMutableParagraphStyle *psNarrow = nil;
    if (!psNarrow) {
        psNarrow = [[NSMutableParagraphStyle alloc] init];
        psNarrow.lineBreakMode = NSLineBreakByWordWrapping;
        psNarrow.paragraphSpacing = 4;
    }
    return psNarrow;
}


+ (NSParagraphStyle *)psNarrowRightAlign {
    static NSMutableParagraphStyle *psNarrowRightAlign = nil;
    if (!psNarrowRightAlign) {
        psNarrowRightAlign = [[NSMutableParagraphStyle alloc] init];
        psNarrowRightAlign.lineBreakMode = NSLineBreakByWordWrapping;
        psNarrowRightAlign.paragraphSpacing = 4;
        psNarrowRightAlign.alignment = NSTextAlignmentRight;
    }
    return psNarrowRightAlign;
}

- (void)setUnit:(UnitInfo *)unit {
    _unit = unit;
    [self updateMiscInfoText];
}

- (void)updateMiscInfoText {
    captionText = nil;
    captionText = [[self class] assembleCaptionText:self.unit];
    
    contentText = nil;
    contentText = [[self class] assembleContentText:self.unit];
}

+ (CGFloat)calculateHeightForUnit:(UnitInfo *)unit {
    NSAttributedString *attrString = [[self class]assembleContentText:unit];
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(MISC_TEXT_WIDTH, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           context:nil];
    return rect.size.height + 20;

}

+ (NSAttributedString *)assembleCaptionText:(UnitInfo *)unit {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    UIColor *captionColor = [UIColor grayColor];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"基本信息"
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                NSParagraphStyleAttributeName:[self.class psWide]}]];
    
    NSMutableString *captionString = [[NSMutableString alloc] init];
    [captionString appendString: @"\n地形\n战斗类型"];
    if (unit.sniping || unit.modification || unit.oversize || unit.repair) {
        [captionString appendString:@"\n"];
    }
    
    [captionString appendString:@"\n势力"];
    if (unit.groupName2.length) {
        [captionString appendString: @"\n"];
    }
    [captionString appendString:@"\n特色\n出自作品\n驾驶员\n登场时间"];
    
    
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:captionString
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                                NSParagraphStyleAttributeName:[self.class psNarrowRightAlign],
                                                                                NSForegroundColorAttributeName:captionColor}]];
    return result;
}

+ (NSAttributedString *)assembleContentText:(UnitInfo *)unit {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    UIColor *contentColor = [UIColor blackColor];
    
    // draw fake title caption
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\x20"
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                NSParagraphStyleAttributeName:[self.class psWide]}]];
    
    
    NSMutableString *contentString = [[NSMutableString alloc] init];
    [contentString appendString:[NSString stringWithFormat:@"\n%@\n%@",
                                 unit.landform,
                                 unit.warType ]];
    if (unit.sniping || unit.modification || unit.oversize || unit.repair) {
        NSString *_4pString = [NSString stringWithFormat:@"%@%@%@%@",
                               unit.modification ? @"变形 " : @"",
                               unit.oversize ? @"大型 ": @"",
                               unit.repair ? @"修理 " : @"",
                               unit.sniping ? @"狙击 " : @""];

        [contentString appendString:[NSString stringWithFormat:@"\n%@", _4pString]];
    }
    
    [contentString appendString:[NSString stringWithFormat:@"\n%@", unit.groupName1]];
    if (unit.groupName2.length) {
        [contentString appendString:[NSString stringWithFormat:@"\n%@", unit.groupName2]];
    }
    [contentString appendString:[NSString stringWithFormat:@"\n%@\n%@\n%@\n%@",
                                 unit.feature,
                                 unit.originTitle,
                                 unit.driver,
                                 unit.regdate]];

    [result appendAttributedString:[[NSAttributedString alloc] initWithString:contentString
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                                NSForegroundColorAttributeName:contentColor,
                                                                                NSParagraphStyleAttributeName:[self.class psNarrow]}]];
    
    return result;
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
    
    if (captionText) {
        [captionText drawInRect:CGRectMake(MISC_CELL_PADDING, 10, 60, CGFLOAT_MAX)];
    }
    
    if (contentText) {
        [contentText drawInRect:CGRectMake(95, 10, MISC_TEXT_WIDTH, CGFLOAT_MAX)];
    }
}

@end
