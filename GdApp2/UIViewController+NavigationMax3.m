//
//  UIViewController+UIViewController_NavigationMax3.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/7/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UIViewController+NavigationMax3.h"

@implementation UIViewController (NavigationMax3)

- (void)configureNavigationMax3 {
    if (self.navigationController && self.navigationController.viewControllers.count > 3) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backToTopViewController)];
        [self.navigationItem setLeftBarButtonItem:closeButton];
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)backToTopViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
