//
//  GundamBoundStyleButton.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/1/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GundamStyleBorderedButton.h"

@implementation GundamStyleBorderedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    
    CGContextSetLineWidth(ctx, 2);

    // draw horizontal & vertical lines
    if ((self.cutCorners & CutCornerNW) == CutCornerNW) {
        CGContextMoveToPoint(ctx, self.cutCornerSize, 0);
    } else {
        CGContextMoveToPoint(ctx, 0, 0);
    }
    
    if ((self.cutCorners & CutCornerNE) == CutCornerNE) {
        CGContextAddLineToPoint(ctx, self.bounds.size.width - self.cutCornerSize, 0);
        CGContextMoveToPoint(ctx, self.bounds.size.width, self.cutCornerSize);
    } else {
        CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
    }
    
    if ((self.cutCorners & CutCornerSE) == CutCornerSE) {
        CGContextAddLineToPoint(ctx, self.bounds.size.width,  self.bounds.size.height - self.cutCornerSize);
        CGContextMoveToPoint(ctx, self.bounds.size.width - self.cutCornerSize, self.bounds.size.height);
    } else {
        CGContextAddLineToPoint(ctx, self.bounds.size.width,  self.bounds.size.height);
    }
    
    if ((self.cutCorners & CutCornerSW) == CutCornerSW) {
        CGContextAddLineToPoint(ctx, self.cutCornerSize, self.bounds.size.height);
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height - self.cutCornerSize);
    } else {
        CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
    }
    
    if ((self.cutCorners & CutCornerNW) == CutCornerNW) {
        CGContextAddLineToPoint(ctx, 0, self.cutCornerSize);
    } else {
        CGContextAddLineToPoint(ctx, 0, 0);
    }
    
    CGContextStrokePath(ctx);

    
    // draw cut corners
    CGContextSetLineWidth(ctx, 1);
    
    if ((self.cutCorners & CutCornerNW) == CutCornerNW) {
        CGContextMoveToPoint(ctx, 0, self.cutCornerSize);
        CGContextAddLineToPoint(ctx, self.cutCornerSize, 0);
    }
    
    if ((self.cutCorners & CutCornerNE) == CutCornerNE) {
        CGContextMoveToPoint(ctx, self.bounds.size.width - self.cutCornerSize, 0);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.cutCornerSize);
    }
    
    if ((self.cutCorners & CutCornerSE) == CutCornerSE) {
        CGContextMoveToPoint(ctx, self.bounds.size.width, self.bounds.size.height - self.cutCornerSize);
        CGContextAddLineToPoint(ctx, self.bounds.size.width - self.cutCornerSize,  self.bounds.size.height);
    }
    
    if ((self.cutCorners & CutCornerSW) == CutCornerSW) {
        CGContextMoveToPoint(ctx, self.cutCornerSize, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, 0, self.bounds.size.height - self.cutCornerSize);
    }
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
}

@end
