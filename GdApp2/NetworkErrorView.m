//
//  NetworkNAView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/2/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "NetworkErrorView.h"

@interface NetworkErrorView()

@property (strong, nonatomic) UIImageView *wifiLogoImageView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *reloadButton;

@end

@implementation NetworkErrorView

- (UIImageView *)wifiLogoImageView {
    if (!_wifiLogoImageView) {
        CGRect parentFrame = self.frame;
        CGSize logoSize = CGSizeMake(180, 180);
        _wifiLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((parentFrame.size.width - logoSize.width) / 2, 90, logoSize.width, logoSize.height)];
        _wifiLogoImageView.image = [UIImage imageNamed:@"wifi-logo"];
        _wifiLogoImageView.alpha = 0.3;
        [self addSubview:_wifiLogoImageView];
    }
    return _wifiLogoImageView;
}

-(UILabel *)messageLabel {
    if (!_messageLabel) {
        CGRect parentFrame = self.frame;
        CGSize labelSize = CGSizeMake(180, 60);
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((parentFrame.size.width - labelSize.width) / 2, 260, labelSize.width, labelSize.height)];
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.numberOfLines = 2;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"网络不给力啊\n要不过一会再试试看?";
        _messageLabel.alpha = 0.3;
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        CGRect parentFrame = self.frame;
        CGSize buttonSize = CGSizeMake(90, 32);
        _reloadButton = [[UIButton alloc] initWithFrame:CGRectMake((parentFrame.size.width - buttonSize.width) / 2, 340, buttonSize.width, buttonSize.height)];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _reloadButton.layer.cornerRadius = 3;
        _reloadButton.layer.borderWidth = 1;
        _reloadButton.layer.borderColor = [UIColor grayColor].CGColor;
        [_reloadButton addTarget:self action:@selector(performReload:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_reloadButton];
    }
    return _reloadButton;
}

- (void)performReload:(UIButton *)sender {
    if (self.reloadCallback) {
        self.reloadCallback();
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
        [self wifiLogoImageView];
        [self messageLabel];
        [self reloadButton];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(performReload:)]];
    }
    return self;
}

+ (void)showNEVAddTo:(UIView *)view reloadCallback:(void (^)())callback {
    NetworkErrorView *nev = [[NetworkErrorView alloc] initWithFrame:view.frame];
    nev.reloadCallback = callback;
    [view addSubview:nev];
}

+ (BOOL)hideNEVForView:(UIView *)view {
    NetworkErrorView *nev = [self NEVForView:view];
	if (nev != nil) {
		[nev removeFromSuperview];
		return YES;
	}
	return NO;
}

+ (instancetype)NEVForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (NetworkErrorView *)subview;
		}
	}
	return nil;
}



//
//- (id)initWithParentView:(UIView *)parentView reload:(void (^)())reload {
//    self = [super init];
//    if (self) {
//        self.parentView = parentView;
//        self.reloadCallback = reload;
//    }
//}
//


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
