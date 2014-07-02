//
//  UnitCollectionViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDUnitCollectionViewCell2.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GDUnitCollectionViewCell2()

@property (strong, nonatomic) UIImage *unitImage;

@end

@implementation GDUnitCollectionViewCell2

static const CGFloat UNIT_IMAGE_WIDTH = 79;
static const CGFloat UNIT_IMAGE_PADDING = 4;
static const CGFloat TEXT_PADDING = 3;

- (void)setUnitId:(NSString *)unitId {
    _unitId = unitId;

    if (![self displayCachedImageForUnitId:unitId] && self.showRemoteImage) {
        [[SDWebImageManager sharedManager] downloadWithURL:[GDAppUtility URLForUnitImageOfUnitId:unitId]
                                                   options:0
                                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                      // progression tracking code
                                                  }
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (image && finished) {
                                                         // NSLog(@"local: %@ self: %@", unitId, self.unitId);
                                                         if ([unitId isEqualToString:self.unitId]) {
                                                             self.unitImage = image;
                                                             [self setNeedsDisplay];
                                                         } else {
                                                             // find in cache again
                                                             // NSLog(@"2nd hit for current!");
                                                             [self displayCachedImageForUnitId:self.unitId];
                                                         }
                                                         
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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _unitImage = nil;
    _modelName = nil;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
    CGContextFillRect(ctx, rect);

    CGFloat unitImageBorderSize = UNIT_IMAGE_WIDTH + UNIT_IMAGE_PADDING;
    CGRect unitImageBorderRect = CGRectMake((rect.size.width - unitImageBorderSize) / 2, 4, unitImageBorderSize, unitImageBorderSize);
    
    // draw border
    UIColor *borderColor = [UIColor colorWithRed:195/255 green:195/255 blue:195/255 alpha:0.18];
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    
    CGContextMoveToPoint(ctx, unitImageBorderRect.origin.x, unitImageBorderRect.origin.y);
    CGContextAddLineToPoint(ctx, unitImageBorderRect.origin.x + unitImageBorderRect.size.width, unitImageBorderRect.origin.y);
    CGContextAddLineToPoint(ctx, unitImageBorderRect.origin.x + unitImageBorderRect.size.width, unitImageBorderRect.origin.y + unitImageBorderRect.size.height);
    CGContextAddLineToPoint(ctx, unitImageBorderRect.origin.x, unitImageBorderRect.origin.y + unitImageBorderRect.size.height);
    CGContextAddLineToPoint(ctx, unitImageBorderRect.origin.x, unitImageBorderRect.origin.y);
    CGContextStrokePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:0.7] CGColor]);
    CGContextFillRect(ctx, unitImageBorderRect);

    CGFloat unitImageLeft = (rect.size.width - UNIT_IMAGE_WIDTH) / 2;
    CGFloat unitImagePadding = unitImageLeft - unitImageBorderRect.origin.x;
    CGRect imageRect = CGRectMake(unitImageLeft, unitImageBorderRect.origin.y + unitImagePadding, UNIT_IMAGE_WIDTH, UNIT_IMAGE_WIDTH);
    if (self.unitImage) {
        [self.unitImage drawInRect:imageRect];
    } else {
        UIImage *plageHolder = [UIImage imageNamed:@"placeholder-unit"];
        [plageHolder drawInRect:imageRect];
    }
    
    if (self.modelName) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];

        [self.modelName drawInRect:CGRectMake(TEXT_PADDING, unitImageBorderRect.origin.y + unitImageBorderRect.size.height + TEXT_PADDING,
                                              rect.size.width - 2 * TEXT_PADDING, CGFLOAT_MAX)
                    withAttributes:@{NSParagraphStyleAttributeName: style,
                                     NSFontAttributeName: [UIFont systemFontOfSize:12],
                                     NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    }
}

@end
