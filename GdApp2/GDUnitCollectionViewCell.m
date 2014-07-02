//
//  GDUnitCollectionViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/29/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDUnitCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface GDUnitCollectionViewCell()

@property (strong, nonatomic) UIImage *unitImage;

@end

@implementation GDUnitCollectionViewCell

static const CGFloat UNIT_IMAGE_WIDTH = 77.5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setUnitId:(NSString *)unitId {
    _unitId = unitId;
    
    if (![self displayCachedImageForUnitId:unitId]) {
        [[SDWebImageManager sharedManager] downloadWithURL:[GDAppUtility URLForUnitImageOfUnitId:unitId]
                                                                        options:0
                                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                           // progression tracking code
                                                                       }
                                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                                          if ([unitId isEqualToString:self.unitId]) {
                                                                              self.unitImage = image;
                                                                              [self setNeedsDisplay];
                                                                          } else {
                                                                              // find in cache again
                                                                              // NSLog(@"2nd hit for current!");
                                                                              [self displayCachedImageForUnitId:self.unitId];
                                                                          }
                                                                      }
                                                            ];
    }
}

- (BOOL)displayCachedImageForUnitId:(NSString *)unitId {
    UIImage *image = [GDAppUtility unitImageFromSDImageCache:unitId];
    if (image) {
        self.unitImage = image;
        [self setNeedsDisplay];
        return YES;
    }
    return NO;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _unitImage = nil;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *borderColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    
//    if ((self.border & GDCVCellBorderTop) == GDCVCellBorderTop) {
//        CGContextMoveToPoint(ctx, 0, 0);
//        CGContextAddLineToPoint(ctx, rect.size.width, 0);
//        
//        CGContextStrokePath(ctx);
//    }
//    
//    if ((self.border & GDCVCellBorderBottom) == GDCVCellBorderBottom) {
//        CGContextMoveToPoint(ctx, 0, rect.size.height);
//        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
//        
//        CGContextStrokePath(ctx);
//    }
    
    if ((self.border & GDCVCellBorderLeft) == GDCVCellBorderLeft) {
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, 0, rect.size.height);
        
        CGContextStrokePath(ctx);
    }
    
    if ((self.border & GDCVCellBorderRight) == GDCVCellBorderRight) {
        CGContextMoveToPoint(ctx, rect.size.width, 0);
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
        
        CGContextStrokePath(ctx);
    }

    CGFloat padding = (rect.size.width - UNIT_IMAGE_WIDTH) / 2;
    CGRect imageRect = CGRectMake(padding, padding, UNIT_IMAGE_WIDTH, UNIT_IMAGE_WIDTH);
    if (self.unitImage) {
        [self.unitImage drawInRect:imageRect];
    } else {
        UIImage *plageHolder = [UIImage imageNamed:@"placeholder-unit"];
        [plageHolder drawInRect:imageRect];
    }

}

@end
