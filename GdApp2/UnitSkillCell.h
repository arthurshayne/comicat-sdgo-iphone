//
//  UnitSkillCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface UnitSkillCell : ABTableViewCell {
    NSAttributedString *skillText;
}

@property (nonatomic) uint skillId;
@property (strong, nonatomic) NSString *skillName;
@property (strong, nonatomic) NSString *skillDesc;
@property (strong, nonatomic) NSString *skillEx;

- (void)updateSkillText;
+ (CGFloat)calculateCellHeightForSkillName:(NSString *)skillName skillDesc:(NSString *)skillDesc skillEx:(NSString *)skillEx;

@end
