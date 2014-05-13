//
//  GDPostCategoryView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/3/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDPostCategoryViewDelegate.h"

@interface GDPostCategoryView : UIScrollView

@property (nonatomic) int gdPostCategory;
@property (weak, nonatomic) id<GDPostCategoryViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize;

@end
