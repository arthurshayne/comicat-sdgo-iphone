//
//  UnitStoryCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/7/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitStoryCell.h"

@implementation UnitStoryCell

const CGFloat STORY_TEXT_WIDTH = 280;
const CGFloat STORY_CELL_PADDING = 23;

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
        psNarrow.paragraphSpacing = 3;
        psNarrow.lineSpacing = 2;
    }
    return psNarrow;
}

- (void)setStory:(NSString *)story {
    _story = story;
    [self updateStoryText];
}

- (void)updateStoryText {
    storyText = [[self class ] assembleStoryText:self.story];
}

+ (CGFloat)calculateHeight:(NSString *)story {
    NSAttributedString *attrString = [[self class] assembleStoryText:story];
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(STORY_TEXT_WIDTH, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           context:nil];
    return rect.size.height + 20;
}

+ (NSAttributedString *)assembleStoryText:(NSString *)story {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"介绍\n"
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                NSParagraphStyleAttributeName:[self.class psWide]}]];
    // NSString *shortened = [story substringToIndex:60];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:story
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                                NSParagraphStyleAttributeName:[self.class psNarrow]}]];
//    if (shortened.length >= story.length) {
//        self.expanded = YES;
//    }
    
//    if (!self.expanded) {
//        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"更多"
//                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
//                                                                                    NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:0.29 blue:0.27 alpha:1],
//                                                                                    NSParagraphStyleAttributeName:[self.class psNarrow] }]];
//    }
    
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
    
    if (storyText) {
        [storyText drawInRect:CGRectMake(STORY_CELL_PADDING, 10, STORY_TEXT_WIDTH, CGFLOAT_MAX)];
    }
}

@end
