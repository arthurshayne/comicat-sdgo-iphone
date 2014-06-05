//
//  ScrollingTextView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollingTextView : UIView {
    NSTimer * scroller;
    CGPoint point;
    CGFloat stringWidth;
    BOOL running;
    BOOL ranOnce;
}

@property (nonatomic, copy) NSString * text;
@property (nonatomic) NSTimeInterval speed;

@end
