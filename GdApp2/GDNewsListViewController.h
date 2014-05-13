//
//  GDNewsListViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/11/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDPostCategoryViewDelegate.h"
#import "GDManagerDelegate.h"

@interface GDNewsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GDPostCategoryViewDelegate, GDManagerDelegate>

@end
