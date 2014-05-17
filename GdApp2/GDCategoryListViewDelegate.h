//
//  GDCategoryListViewDelegate.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/17/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDCategoryListViewDelegate <UIScrollViewDelegate>

@optional
- (void)tappedOnCategoryViewWithCategory:(int)category;
- (void)tappedOnShowAll;
@end
