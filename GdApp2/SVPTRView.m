//
//  SVPTRStoppedView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/29/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "SVPTRView.h"
@interface SVPTRView()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation SVPTRView

+ (UIFont *)fontForText {
    static UIFont *fontForText = nil;
    if (fontForText == nil) {
        fontForText = [UIFont boldSystemFontOfSize:14];
    }
    return fontForText;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)viewOfStoppedStateWithFrame:(CGRect)frame {
    SVPTRView *view = [[SVPTRView alloc] initWithFrame:frame];
    view.state = SVPullToRefreshStateStopped;

    return view;
}

+ (instancetype)viewOfTriggeredStateWithFrame:(CGRect)frame {
    SVPTRView *view = [[SVPTRView alloc] initWithFrame:frame];
    view.state = SVPullToRefreshStateTriggered;
    
    return view;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

//- (void)willMoveToWindow:(UIWindow *)newWindow {
//    NSLog(@"willMoveToWindow %d", self.state);
//}

- (void)drawRect:(CGRect)rect {
    CGRect textFrame = CGRectMake(62, 10, 120, 21);
    CGRect imageFrame = CGRectMake(0, 0, 39.5, 30);
    
    if (self.state == SVPullToRefreshStateStopped) {
        [[UIImage imageNamed:@"haro-grayscale"] drawInRect:imageFrame];
        
        [@"下拉刷新..." drawInRect:textFrame
         withAttributes:@{ NSFontAttributeName:[self.class fontForText],
                           NSForegroundColorAttributeName:[UIColor grayColor]
                           }];
    } else if (self.state == SVPullToRefreshStateTriggered) {
        [[UIImage imageNamed:@"haro-red"] drawInRect:imageFrame];
        
        [@"放开刷新..." drawInRect:textFrame
                withAttributes:@{ NSFontAttributeName:[self.class fontForText],
                                  NSForegroundColorAttributeName:[UIColor grayColor]
                                  }];
    } else if (self.state == SVPullToRefreshStateLoading) {
        
    }
}


@end
