//
//  GDCategoryListView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/17/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDCategoryListView.h"
#import "Utility.h"

#import "GDPostCategoryView.h"

@interface GDCategoryListView ()

@property (strong, nonatomic) UIButton *showAllButton;
@property (strong, nonatomic) NSArray *categoryViews;
@property (strong, nonatomic) UIView *categorySelection;

@end

@implementation GDCategoryListView

const CGFloat GD_CATEGORY_ITEM_WIDTH = 55;
const CGFloat GD_CATEGORY_ITEM_HEIGHT = 22;
const CGFloat GD_CATEGORY_ITEM_MARGIN = 5;

- (void)setGdCategoryList:(NSArray *)gdCategoryList {
    _gdCategoryList = gdCategoryList;
    
    CGFloat showAllButtonWidth = self.showAllButton.frame.size.width;
    for (int i = 0; i < gdCategoryList.count; i++) {
        int gdCategory = [(NSNumber *)[gdCategoryList objectAtIndex:i] intValue];
        GDPostCategoryView *gdcv =
        [[GDPostCategoryView alloc] initWithFrame:CGRectMake(GD_CATEGORY_ITEM_MARGIN + i * (GD_CATEGORY_ITEM_WIDTH + GD_CATEGORY_ITEM_MARGIN) +
                                                             GD_CATEGORY_ITEM_MARGIN + showAllButtonWidth,
                                                             GD_CATEGORY_ITEM_MARGIN,
                                                             GD_CATEGORY_ITEM_WIDTH,
                                                             GD_CATEGORY_ITEM_HEIGHT)
                                         fontSize:13];
        gdcv.gdPostCategory = gdCategory;
        gdcv.delegate = self;
        
        [self addSubview:gdcv];
    }
    
    self.contentSize =
        CGSizeMake(self.gdCategoryList.count * (GD_CATEGORY_ITEM_WIDTH + GD_CATEGORY_ITEM_MARGIN) + GD_CATEGORY_ITEM_MARGIN + GD_CATEGORY_ITEM_MARGIN + showAllButtonWidth, 10);
    self.contentOffset = CGPointMake(showAllButtonWidth + GD_CATEGORY_ITEM_MARGIN, 0);
}

- (void)setCurrentGDCategory:(int)currentGDCategory {
    _currentGDCategory = currentGDCategory;
    
    if (currentGDCategory > 0) {
        
        CGFloat showAllButtonWidth = self.showAllButton.frame.size.width;
        NSUInteger index = [self.gdCategoryList indexOfObject:[NSNumber numberWithInt:currentGDCategory]];
        self.categorySelection.frame =
        CGRectMake(GD_CATEGORY_ITEM_MARGIN + index * (GD_CATEGORY_ITEM_WIDTH + GD_CATEGORY_ITEM_MARGIN) +
                   GD_CATEGORY_ITEM_MARGIN + showAllButtonWidth,
                   GD_CATEGORY_ITEM_HEIGHT + 6,
                   GD_CATEGORY_ITEM_WIDTH,
                   2);
        self.categorySelection.hidden = NO;
        
    } else {
        self.categorySelection.hidden = YES;
    }

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showAllButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 2, 72, 30)];
        // self.showAllButton.backgroundColor = [Utility UIColorFromRGB:0x999999];
        [self.showAllButton setTitle:@"显示全部" forState:UIControlStateNormal];
        [self.showAllButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.showAllButton setTintColor:[Utility UIColorFromRGB:0xFF4A45]];
        [self.showAllButton setTitleColor:[Utility UIColorFromRGB:0xFF4A45] forState:UIControlStateNormal];
        
        [self.showAllButton addTarget:self action:@selector(tappedOnShowAll) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.showAllButton];
        
        self.categorySelection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 2)];
        self.categorySelection.backgroundColor = [Utility UIColorFromRGB:0xFF4A45];
        self.categorySelection.hidden = YES;
        [self addSubview:self.categorySelection];
        
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)tappedOnCategoryViewWithCategory:(int)category {
    self.currentGDCategory = category;
    [self.delegate tappedOnCategoryViewWithCategory:category];
}

- (void)tappedOnShowAll {
    self.currentGDCategory = 0;
    [self.delegate tappedOnShowAll];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
