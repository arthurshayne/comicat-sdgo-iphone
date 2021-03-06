//
//  UnitMiscInfoCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "UnitInfo.h"

@interface UnitMiscInfoCell : ABTableViewCell {
    NSAttributedString *captionText;
    NSAttributedString *contentText;
}

@property (strong, nonatomic) UnitInfo *unit;

+ (CGFloat)calculateHeightForUnit:(UnitInfo *)unit;

@end
