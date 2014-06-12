//
//  OriginTableViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "OriginTableViewCell.h"
#import "ABTableViewCell.h"
#import "GundamOrigin.h"

@implementation OriginTableViewCell

- (void)setOriginIndex:(NSString *)originIndex {
    _originIndex = originIndex;
    
    originTitle = [[[GundamOrigin originTitles] objectForKey:_originIndex] copy];
    originImage = [UIImage imageNamed:[NSString stringWithFormat:@"origin-%@", self.originIndex]];
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
	CGRect b = [self bounds];
	[contentView setFrame:b];
    [super layoutSubviews];
}

- (void)prepareForReuse {
    originTitle = nil;
    originImage = nil;
}

- (void)drawContentView:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextFillRect(ctx, rect);
    
    if (originImage && originTitle) {
        
        CGFloat imageWidth = 214;
        CGFloat imageHeight = 86;
        CGFloat bannerHeight = 45;
        CGFloat padding = 6;
        
        CGFloat imageOriginX = (rect.size.width - imageWidth) / 2 - 37;
        
        [originImage drawInRect:CGRectMake(imageOriginX, padding, imageWidth, imageHeight)];

    
        [[UIImage imageNamed:@"bg_video_large"] drawInRect:CGRectMake(imageOriginX, padding + imageHeight - bannerHeight, imageWidth, bannerHeight)];

        // text
        [originTitle drawAtPoint:CGPointMake(imageOriginX + 4, padding + imageHeight - 17)
                       withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
        
        // NSString *numberOfUnits = [NSString stringWithFormat:@"%d台机体", [GundamOrigin]]
    }
}
@end
