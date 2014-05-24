//
//  GDPostCategoryView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/3/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDPostCategoryView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface GDPostCategoryView()

@property (strong, nonatomic) UILabel *categoryTextLabel;

//@property (strong, nonatomic) NSDictionary *gdCategoryTexts;
//@property (strong, nonatomic) NSDictionary *gdCategoryGradientColors;

@end

@implementation GDPostCategoryView

static NSDictionary *_gdCategoryTexts;
+ (NSDictionary *)gdCategoryTexts {
    if (!_gdCategoryTexts) {
        _gdCategoryTexts = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"公告", @1,
                            @"任务", @2,
                            @"机体", @4,
                            @"经验", @8,
                            @"国服", @16,
                            @"韩服", @32,
                            @"台服", @64,
                            @"日服", @128,
                            @"港服", @256,
                            @"美服", @512,
                            @"泰服", @1024,
                            @"海服", @2048,
                            nil];
    }
    return _gdCategoryTexts;
}

static NSDictionary *_gdCategoryGradientColors;
+ (NSDictionary *)gdCategoryGradientColors {
    if (!_gdCategoryGradientColors) {
        _gdCategoryGradientColors = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x6F96C1).CGColor, (id)UIColorFromRGB(0x2F5587).CGColor, nil], @1,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0xFEFEFE).CGColor, (id)UIColorFromRGB(0xC6C6C6).CGColor, nil], @2,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0xC3B150).CGColor, (id)UIColorFromRGB(0x7F6C20).CGColor, nil], @4,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x7259C3).CGColor, (id)UIColorFromRGB(0x391A8F).CGColor, nil], @8,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x72BB7F).CGColor, (id)UIColorFromRGB(0x368142).CGColor, nil], @16,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x505050).CGColor, (id)UIColorFromRGB(0x262626).CGColor, nil], @32,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0xE488B3).CGColor, (id)UIColorFromRGB(0xDB6195).CGColor, nil], @64,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x63C3C0).CGColor, (id)UIColorFromRGB(0x368986).CGColor, nil], @128,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0xB765A6).CGColor, (id)UIColorFromRGB(0x7E2B6C).CGColor, nil], @256,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x364A7C).CGColor, (id)UIColorFromRGB(0x172345).CGColor, nil], @512,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x806B35).CGColor, (id)UIColorFromRGB(0x443713).CGColor, nil], @1024,
                                     [NSArray arrayWithObjects:(id)UIColorFromRGB(0x784932).CGColor, (id)UIColorFromRGB(0x422211).CGColor, nil], @2048,
                                     nil];
    }
    return _gdCategoryGradientColors;
}

- (id)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = YES;
//        
//        self.categoryTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        
//        self.categoryTextLabel.backgroundColor = [UIColor clearColor];
//        //        self.categoryTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        //        self.categoryTextLabel.adjustsFontSizeToFitWidth = YES;
//        self.categoryTextLabel.font = [UIFont systemFontOfSize:fontSize];
//        self.categoryTextLabel.textAlignment = NSTextAlignmentCenter;
//        self.categoryTextLabel.userInteractionEnabled = YES;
//        //        self.categoryTextLabel.multipleTouchEnabled = YES;
//        
//        [self addSubview:self.categoryTextLabel];
    }
    return self;
}

- (void)setGdPostCategory:(int)gdPostCategory {
    _gdPostCategory = gdPostCategory;
    
//    CAGradientLayer *layer = [self getGdPostCategoryBackground:gdPostCategory];
//    
//    // [self.layer insertSublayer:layer atIndex:0];
//    [self.layer addSublayer:layer];
//    
//    self.categoryTextLabel.text = [NSString stringWithFormat:@"%@", [self getGdPostCategoryText:gdPostCategory]];
//    // self.categoryTextLabel.text = [NSString stringWithFormat:@"%d", gdPostCategory];
//    self.categoryTextLabel.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = YES;
    
    [self addGestureRecognizer:tap];
    
//    [self bringSubviewToFront:self.categoryTextLabel];
}

- (void) tapped:(UITapGestureRecognizer *)gesture {
    [self.delegate tappedOnCategoryViewWithCategory:self.gdPostCategory];
}

//- (NSString *) getGdPostCategoryText:(int)gdPostCategory {
//    return [[self.class gdCategoryTexts] objectForKey:[NSNumber numberWithInt:gdPostCategory]];
//}
//
//static NSCache *categoryLayerCache;
//- (CAGradientLayer *) getGdPostCategoryBackground:(int)gdPostCategory {
//    //    if (categoryLayerCache == nil) {
//    //        categoryLayerCache = [[NSCache alloc] init];
//    //        categoryLayerCache.countLimit = 200;
//    //    }
//    //
//    //    NSString *cacheKey =
//    //        [NSString stringWithFormat:@"%d:%f:%f:%d", gdPostCategory, self.frame.size.width, self.frame.size.height, self.tag];
//    //
//    //    CAGradientLayer *cached = [categoryLayerCache objectForKey:cacheKey];
//    //    if (cached != nil) {
//    //        //NSLog(@"Cached forKey:%@", cacheKey);
//    //        return cached;
//    //    }
//    //
//    //    NSLog(@"getGdPostCategoryBackground %d", gdPostCategory);
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    NSArray *colors = [[self.class gdCategoryGradientColors] objectForKey:[NSNumber numberWithInt:gdPostCategory]];
//    
//    if (colors) {
//        gradient.colors = colors;
//        gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        gradient.startPoint = CGPointMake(0.5, 0.0);
//        gradient.endPoint = CGPointMake(0.5, 1.0);
//        
//        gradient.shouldRasterize = YES;
//        gradient.rasterizationScale = [UIScreen mainScreen].scale;
//        
//        gradient.cornerRadius = self.frame.size.width / 10;
//        gradient.masksToBounds = NO;
//        gradient.opaque = YES;
//
//        //NSLog(@"Stored: %@", cacheKey);
//        //        [categoryLayerCache setObject:gradient forKey:cacheKey];
//        
//        return gradient;
//    } else {
//        return nil;
//    }
//}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(ctx, rect);

    [[UIImage imageNamed:[NSString stringWithFormat:@"l-%d", self.gdPostCategory]] drawInRect:rect];
    //[[UIImage imageNamed:@"l-1"] drawInRect:rect];
}


@end
