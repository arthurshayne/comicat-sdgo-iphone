//
//  GDVideoListCollectionViewCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDVideoListCollectionViewCell.h"
#import "GDAppUtility.h"
#import "NSDate+PrettyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GDVideoListCollectionViewCell ()

// TODO: Change to accept single NSStrings instead of a VLI object

@property (retain, nonatomic) UIImage *titleImage;
@property (strong, nonatomic) NSString *dateString;

@end

@implementation GDVideoListCollectionViewCell

+ (UIFont *)fontForTitle {
    static UIFont *fontForTitle = nil;
    if (fontForTitle == nil) {
        fontForTitle = [UIFont systemFontOfSize:12];
    }
    return fontForTitle;
}

+ (UIFont *)fontForTitle2 {
    static UIFont *fontForTitle2 = nil;
    if (fontForTitle2 == nil) {
        fontForTitle2 = [UIFont systemFontOfSize:12];
    }
    return fontForTitle2;
}

+ (UIFont *)fontForDate {
    static UIFont *fontForDate = nil;
    if (fontForDate == nil) {
        fontForDate = [UIFont systemFontOfSize:11];
    }
    return fontForDate;
}


+ (NSParagraphStyle *)truncateTailPS {
    static NSMutableParagraphStyle *truncateTailPS = nil;
    if (!truncateTailPS) {
        truncateTailPS = [[NSMutableParagraphStyle alloc] init];
        truncateTailPS.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return truncateTailPS;
}

+ (NSParagraphStyle *)truncateTailRightPS {
    static NSMutableParagraphStyle *truncateTailCenterPS = nil;
    if (!truncateTailCenterPS) {
        truncateTailCenterPS = [[NSMutableParagraphStyle alloc] init];
        truncateTailCenterPS.lineBreakMode = NSLineBreakByTruncatingTail;
        truncateTailCenterPS.alignment = NSTextAlignmentRight;
    }
    return truncateTailCenterPS;
}

//+ (CGColorRef)bgColorForTitle2 {
//    static CGColorRef bgColorForTitle2 = nil;
//    if (!bgColorForTitle2) {
//        
//    }
//    return bgColorForTitle2;
//}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setVideoListItem:(VideoListItem *)videoListItem {
    _videoListItem = videoListItem;
    _dateString = [GDAppUtility dateStringByDay:self.videoListItem.created];
    [self setNeedsDisplay];
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.videoListItem.imageURL]
                                               options:0
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                  // progression tracking code
                                              }
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (image && finished) {
                                                     self.titleImage = image;
                                                     [self setNeedsDisplayInRect:CGRectMake(0, 0, 150, 84)];
                                                 }
                                             }
     ];
}

- (void)drawRect:(CGRect)rect {
    if (self.videoListItem) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();

        CGRect imageRect = CGRectMake(0, 0, 150, 84);
        UIColor *bgColorForTitle2 = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
        
        // NSLog(@"drawing %d", self.videoListItem.postId);
        
        if (self.titleImage) {
            [self.titleImage drawInRect:imageRect];
            
            CGContextSaveGState(ctx);
            CGContextAddRect(ctx, CGRectMake(0, 67, 150, 17));
            CGContextSetFillColorWithColor(ctx, [bgColorForTitle2 CGColor]);
            CGContextFillPath(ctx);
            CGContextRestoreGState(ctx);
            
            [self.videoListItem.title2 drawInRect:CGRectMake(0, 67, 150, 17)
                                   withAttributes:@{ NSFontAttributeName:[self.class fontForTitle2],
                                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                                     NSParagraphStyleAttributeName:[self.class truncateTailRightPS]
                                                     }];
        } else {
            UIImage *plageHolder = [UIImage imageNamed:@"placeholder-small"];
            [plageHolder drawInRect:imageRect];
        }
        
        [self.videoListItem.title drawInRect:CGRectMake(0, 84, 150, 21)
                    withAttributes:@{ NSFontAttributeName:[self.class fontForTitle],
                                      NSForegroundColorAttributeName:[UIColor blackColor],
                                      NSParagraphStyleAttributeName:[self.class truncateTailPS]
                                    }];
        
        
        [self.dateString drawInRect:CGRectMake(36, 106, 110, 17)
                     withAttributes:@{ NSFontAttributeName:[self.class fontForDate],
                                       NSForegroundColorAttributeName:[UIColor grayColor],
                                       NSParagraphStyleAttributeName:[self.class truncateTailPS]
                                    }];
        
        [[UIImage imageNamed:[NSString stringWithFormat:@"s-%d", self.videoListItem.gdPostCategory]] drawInRect:CGRectMake(0, 105, 30, 15)];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    NSLog(@"GDVideoListCollectionViewCell prepareForReuse");
    _titleImage = nil;
    _videoListItem = nil;
}

@end
