//
//  GDPostListCVCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/26/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostListCollectionViewCell.h"
#import "GDPostCategoryView.h"
#import "Utility.h"
#import "NSDate+PrettyDate.h"

@interface GDPostListCollectionViewCell ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *dateString;
@property (nonatomic) uint gdCategory;
@property (strong, nonatomic) NSMutableArray *gdCategories;


@property (strong, nonatomic) UILabel *labelForTitle;
@property (strong, nonatomic) UILabel *labelForDate;
@property (strong, nonatomic) GDPostCategoryView *gdCategoryView;

@end

@implementation GDPostListCollectionViewCell

static CGFloat TITLE_LABEL_HEIGHT = 32;
static CGFloat TITLE_LABEL_MARGIN_H = 7;
static CGFloat TITLE_LABEL_MARGIN_V = 6;

static CGFloat CATEGORY_VIEW_HEIGHT = 15;

#pragma mark - Static Property

+ (UIFont *)fontForTitleLabel {
    static UIFont *_fontForTitleLabel;
    if (!_fontForTitleLabel) {
        _fontForTitleLabel = [UIFont systemFontOfSize:24];
    }
    return _fontForTitleLabel;
}

+ (NSParagraphStyle *)truncateTailPS {
    static NSMutableParagraphStyle *truncateTailPS = nil;
    if (!truncateTailPS) {
        truncateTailPS = [[NSMutableParagraphStyle alloc] init];
        truncateTailPS.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return truncateTailPS;
}

+ (UIFont *)fontForDate {
    static UIFont *fontForDate = nil;
    if (fontForDate == nil) {
        fontForDate = [UIFont systemFontOfSize:11];
    }
    return fontForDate;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_MARGIN_H,
                                                                       TITLE_LABEL_MARGIN_V,
                                                                       frame.size.width - 2 * TITLE_LABEL_MARGIN_H,
                                                                       TITLE_LABEL_HEIGHT)];
        self.labelForTitle.font = [self.class fontForTitleLabel];
        self.labelForTitle.adjustsFontSizeToFitWidth = YES;
        self.labelForTitle.numberOfLines = 2;
        self.labelForTitle.opaque = YES;
        //self.labelForTitle.backgroundColor = [Utility UIColorFromRGB:0xff0000];
        
        [self addSubview:self.labelForTitle];
        
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)configureForPostInfo:(PostInfo *)post {
//    self.title = post.title;
    self.dateString = [post.created prettyDate];

    uint gdCategory = post.gdPostCategory;
    
    _gdCategories = [[NSMutableArray alloc] init];
    static uint maxGDCategory = 2048;
    uint temp = maxGDCategory;
    while(gdCategory > 0) {
        if(gdCategory >= temp) {
            [_gdCategories addObject:[NSString stringWithFormat:@"%d", temp]];
            gdCategory -= temp;
        }
        temp = temp >> 1;
    }
    
    self.labelForTitle.text = post.title;
    
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextMoveToPoint(ctx, 10, 10);
//    CGContextAddLineToPoint(ctx, 20, 20);
//    
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGContextStrokePath(ctx);
    
    
    UIColor *borderColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    
    if ((self.border & GDCVCellBorderTop) == GDCVCellBorderTop) {
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, rect.size.width, 0);
        
        CGContextStrokePath(ctx);
    }
    
    if ((self.border & GDCVCellBorderBottom) == GDCVCellBorderBottom) {
        CGContextMoveToPoint(ctx, 0, rect.size.height);
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
        
        CGContextStrokePath(ctx);
    }
    
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
    
    NSUInteger x = TITLE_LABEL_MARGIN_H;
    for (NSString *gdCategory in self.gdCategories) {
        [[UIImage imageNamed:[NSString stringWithFormat:@"s-%@", gdCategory]] drawInRect:CGRectMake(x, 1.5 * TITLE_LABEL_MARGIN_H + TITLE_LABEL_HEIGHT, 30, CATEGORY_VIEW_HEIGHT)];
        x += 34;
    }
    
    [self.dateString drawAtPoint:CGPointMake(x, 1.5 * TITLE_LABEL_MARGIN_H + TITLE_LABEL_HEIGHT)
                 withAttributes:@{ NSFontAttributeName:[self.class fontForDate],
                                   NSForegroundColorAttributeName:[UIColor grayColor],
                                   NSParagraphStyleAttributeName:[self.class truncateTailPS]
                                   }];
}

@end
