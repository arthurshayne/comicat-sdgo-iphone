//
//  UnitStoryCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/7/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface UnitStoryCell : ABTableViewCell {
    NSAttributedString *storyText;
}

@property (strong, nonatomic) NSString *story;
@property (nonatomic) BOOL expanded;

+ (CGFloat)calculateHeight:(NSString *)story;

@end
