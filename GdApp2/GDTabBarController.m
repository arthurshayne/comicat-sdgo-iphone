//
//  GDTabBarController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GDTabBarController.h"

@interface GDTabBarController ()

@end

@implementation GDTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    tabBarItem0.image = [[UIImage imageNamed:@"tab-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.selectedImage = [[UIImage imageNamed:@"tab-home-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    tabBarItem1.image = [[UIImage imageNamed:@"tab-video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"tab-video-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    tabBarItem2.image = [[UIImage imageNamed:@"tab-news"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"tab-news-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
    tabBarItem3.image = [[UIImage imageNamed:@"tab-unit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"tab-unit-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    for (UITabBarItem *item in self.tabBar.items) {
        [self setTabBarTextColor:item];
    }
}

- (void) setTabBarTextColor:(UITabBarItem *)tabBarItem {
    UIColor *tintColor = [UIColor colorWithRed:1 green:0.29 blue:0.27 alpha:1];
    
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tintColor, NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
