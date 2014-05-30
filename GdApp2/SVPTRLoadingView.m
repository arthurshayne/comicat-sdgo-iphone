//
//  SVPTRLoadingView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "SVPTRLoadingView.h"

@interface SVPTRLoadingView ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *textLabel;
@end

@implementation SVPTRLoadingView


- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.center = CGPointMake(17, 19);
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)textlabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, 120, 21)];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = [UIColor grayColor];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // [self.activityIndicatorView startAnimating];
        self.textlabel.text = @"加载中...";
        [self.activityIndicatorView startAnimating];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [SVPTRLoadingView setAnimationsEnabled:NO];
    [super setFrame:frame];
    [SVPTRLoadingView setAnimationsEnabled:YES];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if ([self.window isKeyWindow]) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
}
//
//- (void)didMoveToWindow:(UIWindow *)newWindow {
//    if ([newWindow isKeyWindow]) {
//        [self.activityIndicatorView startAnimating];
//    } else {
//        [self.activityIndicatorView stopAnimating];
//    }
//}

@end


/*
 [self.activityIndicatorView stopAnimating];
 [self rotateArrow:0 hide:NO];
 break;
 
 case SVPullToRefreshStateTriggered:
 [self rotateArrow:(float)M_PI hide:NO];
 break;
 
 case SVPullToRefreshStateLoading:
 [self.activityIndicatorView startAnimating];
 [self rotateArrow:0 hide:YES];
 
 */