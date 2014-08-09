//
//  AFPopupView.m
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "GDPopupView.h"
#import <QuartzCore/QuartzCore.h>

@interface GDPopupView ()

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *backgroundShadowView;

@end

@implementation GDPopupView

static NSTimeInterval POPUP_VIEW_INTERVAL = 0.31;

+(GDPopupView *)popupWithView:(UIView *)popupView {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = keyWindow.rootViewController.view;
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    
    if (rootView.transform.b != 0 && rootView.transform.c != 0) {
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    }
    
    GDPopupView *view = [[GDPopupView alloc] initWithFrame:rect];
    
    view.modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupView.frame.size.width, popupView.frame.size.height)];
    view.modalView.backgroundColor = [UIColor clearColor];
    view.modalView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    view.backgroundShadowView = [[UIView alloc] initWithFrame:view.frame];
    view.backgroundShadowView.backgroundColor = [UIColor blackColor];
    view.backgroundShadowView.alpha = 0.0;
    view.backgroundShadowView.autoresizingMask = view.modalView.autoresizingMask;
    
    [view.modalView addSubview:popupView];
    [view addSubview:view.backgroundShadowView];
    [view addSubview:view.modalView];
    
    UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(hideByTap)];
    [view.backgroundShadowView addGestureRecognizer:hideGesture];
    
    return view;
}

-(void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = keyWindow.rootViewController.view;
    
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    if(rootView.transform.b != 0 && rootView.transform.c != 0)
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    self.frame = rect;
    
    _backgroundShadowView.alpha = 0.0;
    [rootView addSubview:self];
    _modalView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height + _modalView.frame.size.height / 2.0);
    
    [UIView animateWithDuration:POPUP_VIEW_INTERVAL
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundShadowView.alpha = 0.4;
                     }
     
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:POPUP_VIEW_INTERVAL delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _modalView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - _modalView.frame.size.height / 2.0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

-(void)hide {
    [UIView animateWithDuration:0.85 * POPUP_VIEW_INTERVAL
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.0;
                     }
     
                     completion:^(BOOL finished) {
                        [self removeFromSuperview];
                     }];
    
    [UIView animateWithDuration:0.85 * POPUP_VIEW_INTERVAL
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _modalView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height + _modalView.frame.size.height / 2.0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void)hideByTap {
    if (_hideOnBackgroundTap) {
        [self hide];
    }
}

@end
