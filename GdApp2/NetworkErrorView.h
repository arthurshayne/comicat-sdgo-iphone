//
//  NetworkNAView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/2/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkErrorView : UIView

@property (nonatomic, copy) void (^reloadCallback)();

+ (void)showNEVAddTo:(UIView *)view reloadCallback:(void (^)())callback;
+ (BOOL)hideNEVForView:(UIView *)view;

@end
