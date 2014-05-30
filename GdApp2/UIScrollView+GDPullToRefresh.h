//
//  UIScrollView_UIScrollView_GDPTR.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#

@interface UIScrollView (GDPullToRefresh)

- (void)addGDPullToRefreshWithActionHandler:(void (^)(void))actionHandler;

@end


