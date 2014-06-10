//
//  GDVideoListViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDPostCategoryViewDelegate.h"
#import "GDManagerDelegate.h"
#import "GDCategoryListViewDelegate.h"
#import "GDVideoListDSDelegate.h"

@interface GDVideoListViewController : UIViewController <UICollectionViewDelegate, GDCategoryListViewDelegate, GDVideoListDSDelegate>

@end
