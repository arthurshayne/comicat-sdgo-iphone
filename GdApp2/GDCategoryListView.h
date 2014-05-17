//
//  GDCategoryListView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/17/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDPostCategoryViewDelegate.h"
#import "GDCategoryListViewDelegate.h"

@interface GDCategoryListView : UIScrollView <GDPostCategoryViewDelegate>

@property (strong, nonatomic) NSArray *gdCategoryList;
@property (nonatomic) int currentGDCategory;

@property (weak, nonatomic) id<GDCategoryListViewDelegate> delegate;

@end
