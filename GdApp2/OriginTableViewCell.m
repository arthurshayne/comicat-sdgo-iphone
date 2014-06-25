//
//  OriginTableViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "OriginTableViewCell.h"
#import "ABTableViewCell.h"

@interface OriginTableViewCellInner : UIView
@end

@implementation OriginTableViewCellInner

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)r {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, r);
    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
    CGContextFillRect(ctx, r);
    
	[(OriginTableViewCell *)[[self superview] superview] drawContentView:r];
}

@end

@implementation OriginTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithStyle: style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
		contentView = [[OriginTableViewCellInner alloc] initWithFrame:CGRectZero];
		[self addSubview:contentView];
    }
    return self;
}

- (void)setOriginIndex:(NSString *)originIndex {
    _originIndex = originIndex;
    
    originImage = [UIImage imageNamed:[NSString stringWithFormat:@"origin-%@", self.originIndex]];
    
    [self setNeedsDisplay];
}

- (void)setUnitCount:(uint)unitCount {
    _unitCount = unitCount;
    
    if (_unitCount == 0) {
        unitCountAttrStr = nil;
    } else {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"机体数: \n"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}]];
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.unitCount]
                                                                        attributes:@{NSForegroundColorAttributeName:[GDAppUtility UIColorFromRGB:0x82AF1C],
                                                                                     NSFontAttributeName:[UIFont italicSystemFontOfSize:24]}]];
        
        unitCountAttrStr = (NSAttributedString *)attrStr;
    }
}

- (void)layoutSubviews {
	CGRect b = [self bounds];
	[contentView setFrame:b];
    [super layoutSubviews];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

//- (void)prepareForReuse {
//    originImage = nil;
//    self.originTitle = nil;
//    unitCountAttrStr = nil;
//}

- (void)drawContentView:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
    CGContextFillRect(ctx, rect);
    
    CGFloat imageWidth = 214;
    CGFloat imageHeight = 86;
    CGFloat bannerHeight = 45;
    CGFloat padding = 6;
    
    CGFloat imageOriginX = (rect.size.width - imageWidth) / 2 - 37;
    
    if (originImage && self.originTitle) {
        [originImage drawInRect:CGRectMake(imageOriginX, padding, imageWidth, imageHeight)];

        [[UIImage imageNamed:@"bg_video_large"] drawInRect:CGRectMake(imageOriginX, padding + imageHeight - bannerHeight, imageWidth, bannerHeight)];

        // text
        [self.originTitle drawAtPoint:CGPointMake(imageOriginX + 4, padding + imageHeight - 17)
                       withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    }
    
    if (unitCountAttrStr) {
        [unitCountAttrStr drawAtPoint:CGPointMake(imageOriginX + imageWidth + 10, 19)];
    }


}

@end
