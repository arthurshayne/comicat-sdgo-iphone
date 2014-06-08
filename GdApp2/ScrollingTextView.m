//
//  ScrollingTextView.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "ScrollingTextView.h"

@implementation ScrollingTextView

const float SCROLL_TEXT_GAP = 37;

+ (NSDictionary *)textAttributes {
    static NSDictionary *_textAttributes;
    if (!_textAttributes) {
        _textAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16] };
    }
    return _textAttributes;
}

+ (NSDictionary *)textAttributes2 {
    static NSDictionary *_textAttributes2;
    if (!_textAttributes2) {
        _textAttributes2 = @{ NSFontAttributeName:[UIFont systemFontOfSize:16],
                             NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    return _textAttributes2;
}

- (void) setText:(NSString *)newText {
    _text = [newText copy];
    point = CGPointZero;
    
    stringWidth = [newText sizeWithAttributes:[self.class textAttributes]].width;
    
    if (stringWidth >= self.frame.size.width) {
        [self setupScroller];
    }
}

- (void) setSpeed:(NSTimeInterval)newSpeed {
    if (newSpeed != _speed) {
        _speed = newSpeed;
        
        [scroller invalidate];
        scroller = nil;
        if (stringWidth >= self.frame.size.width) {
            [self setupScroller];
        }
    }
}

- (void)setupScroller {
    if (!scroller && _speed > 0 && _text != nil) {
        scroller = [NSTimer scheduledTimerWithTimeInterval:_speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
        running = YES;
    }
}

- (void) moveText:(NSTimer *)timer {
    if (running) {
        point.x = point.x - 0.5f;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)dirtyRect {
    if (point.x + stringWidth < 0) {
        point.x = SCROLL_TEXT_GAP;
    }
    
    if (point.x == 0) {
        running = NO;
        double delayInSeconds = 2.0;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
            running = YES;
        });
    }
    
    [_text drawAtPoint:point withAttributes:[self.class textAttributes]];
    
    if (stringWidth >= self.frame.size.width &&
        point.x < dirtyRect.size.width - stringWidth) {
        
        CGPoint otherPoint = point;
        otherPoint.x += (stringWidth + SCROLL_TEXT_GAP);
        [_text drawAtPoint:otherPoint withAttributes:[self.class textAttributes]];
    }
}

@end
