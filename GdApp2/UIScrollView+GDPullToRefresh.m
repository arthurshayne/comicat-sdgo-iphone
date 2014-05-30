//
//  UIScrollView+GDPullToRefresh.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UIScrollView+GDPullToRefresh.h"
#import "SVPullToRefresh.h"
#import "SVPTRView.h"
#import "SVPTRLoadingView.h"

@implementation UIScrollView (GDPullToRefresh)

- (void)addGDPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler];
    
    CGRect frame = CGRectMake(0, 0, 160, 30);
    
    [self.pullToRefreshView setCustomView:[SVPTRView viewOfStoppedStateWithFrame:frame] forState:SVPullToRefreshStateStopped];
    [self.pullToRefreshView setCustomView:[SVPTRView viewOfTriggeredStateWithFrame:frame] forState:SVPullToRefreshStateTriggered];
    [self.pullToRefreshView setCustomView:[[SVPTRLoadingView alloc] initWithFrame:frame] forState:SVPullToRefreshStateLoading];
}

@end
