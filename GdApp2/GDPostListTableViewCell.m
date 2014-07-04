//
//  GDPostListTableViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostListTableViewCell.h"
#import "GDPostCategoryView.h"
#import "NSDate+PrettyDate.h"

@interface GDPostListTableViewCell ()

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *dateString;
@property (nonatomic) uint gdCategory;
@property (strong, nonatomic) NSMutableArray *gdCategories;
@end

@implementation GDPostListTableViewCell

static CGFloat TITLE_LABEL_X = 14;
static CGFloat TITLE_LABEL_Y = 32;
static CGFloat TITLE_LABEL_WIDTH = 294;

static CGFloat CELL_PADDING = 12;
static CGFloat CATEGORY_VIEW_HEIGHT = 15;
static CGFloat TITLE_LABEL_MARGIN = 4;

#pragma mark - Static Property


+ (UIFont *)fontForTitleLabel {
    static UIFont *_fontForTitleLabel;
    if (!_fontForTitleLabel) {
        _fontForTitleLabel = [UIFont systemFontOfSize:14];
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


- (void)configureForPostInfo:(PostInfo *)post {
    self.title = post.title;
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
    
    [self setNeedsDisplay];
}

#pragma mark - View Protocol
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

+ (CGFloat)cellHeightForPostInfo:(PostInfo *)post {
    CGSize sizeThatFitsTitle = [GDPostListTableViewCell sizeThatFitsTitle:post.title];
    
//    NSLog(@"%@: %f: %f", post.title, sizeThatFitsTitle.width, sizeThatFitsTitle.height);
//    UILabel *mockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, CGFLOAT_MIN)];
//    mockLabel.text = post.title;
//    mockLabel.font = [UIFont systemFontOfSize:14];
//    mockLabel.numberOfLines = 0;
//    CGSize sizeThatFits = [mockLabel sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)];
//    mockLabel.frame = CGRectMake(0, 0, sizeThatFits.width, sizeThatFits.height);
//    
    //adjust the label the the new height.
    return CELL_PADDING + CATEGORY_VIEW_HEIGHT + TITLE_LABEL_MARGIN + sizeThatFitsTitle.height + CELL_PADDING + 18;
}

+ (CGSize)sizeThatFitsTitle:(NSString *)title {
    CGSize maximumLabelSize = CGSizeMake(TITLE_LABEL_WIDTH, CGFLOAT_MAX);
    CGRect textRect = [title boundingRectWithSize:maximumLabelSize
                                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                            attributes:@{NSFontAttributeName:[self.class fontForTitleLabel]}
                                               context:nil];
    return textRect.size;
}

- (void)layoutSubviews
{
	CGRect b = [self bounds];
//	b.size.height -= 1; // leave room for the separator line
//	b.size.width += 30; // allow extra width to slide for editing
//	b.origin.x -= (self.editing && !self.showingDeleteConfirmation) ? 0 : 30; // start 30px left unless editing
	[contentView setFrame:b];
    [super layoutSubviews];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (self.isHighlighted) {
        CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9] CGColor]);
        CGContextFillRect(ctx, r);
    } else {
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(ctx, r);
    }
    
    [self.title drawInRect:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, 90)
            withAttributes:@{ NSFontAttributeName: [self.class fontForTitleLabel],
                              NSForegroundColorAttributeName: [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1],
                              NSParagraphStyleAttributeName:[self.class truncateTailPS]}];
    [self.dateString drawInRect:CGRectMake(TITLE_LABEL_X,
                                           TITLE_LABEL_Y + TITLE_LABEL_MARGIN + 34, 120, 18)
                 withAttributes:@{ NSFontAttributeName:[self.class fontForDate],
                                   NSForegroundColorAttributeName:[UIColor grayColor],
                                   NSParagraphStyleAttributeName:[self.class truncateTailPS]
                                   }];
    
    NSUInteger x = 16;
    for (NSString *gdCategory in self.gdCategories) {
        [[UIImage imageNamed:[NSString stringWithFormat:@"s-%@", gdCategory]] drawInRect:CGRectMake(x, 12, 30, CATEGORY_VIEW_HEIGHT)];
        x += 34;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.title = self.dateString = nil;
    self.gdCategories = nil;
}

@end
