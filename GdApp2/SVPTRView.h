//
//  SVPTRStoppedView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/29/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface SVPTRView : UIView

@property (nonatomic) SVPullToRefreshState state;

+ (instancetype)viewOfStoppedStateWithFrame:(CGRect)frame;
+ (instancetype)viewOfTriggeredStateWithFrame:(CGRect)frame;

@end
