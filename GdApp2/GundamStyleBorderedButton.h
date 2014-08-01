//
//  GundamBoundStyleButton.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 8/1/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CutCornerNW     = 1 << 0,
    CutCornerNE     = 1 << 1,
    CutCornerSW     = 1 << 2,
    CutCornerSE     = 1 << 3,
} CutCorner;

typedef enum : NSUInteger {
    CutCorderStyle1,    // just cut
    CutCorderStyle2,    // cut with extra line
} CutCorderStyle;


@interface GundamStyleBorderedButton : UIButton

@property (nonatomic) CutCorner cutCorners;
@property (nonatomic) CutCorderStyle cutCornerStyle;
@property (nonatomic) CGFloat cutCornerSize;


@end
