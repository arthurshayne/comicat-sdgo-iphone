//
//  UnitWeaponCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface UnitWeaponCell : ABTableViewCell {
    UIImage *weaponImage;
    NSAttributedString *weaponText;
}

@property (nonatomic) uint weaponId;
@property (nonatomic) uint weaponIndex;
@property (strong, nonatomic) NSString *weaponName;
@property (strong, nonatomic) NSString *weaponEffect;
@property (strong, nonatomic) NSString *weaponProperty;
@property (strong, nonatomic) NSString *weaponRange;
@property (strong, nonatomic) NSString *weaponExLine1;
@property (strong, nonatomic) NSString *weaponExLine2;

- (void)updateWeaponText;
+ (CGFloat)calculateCellHeightFor:(uint)weaponIndex
                       weaponName:(NSString *)weaponName
                     weaponEffect:(NSString *)weaponEffect
                   weaponProperty:(NSString *)weaponProperty
                      weaponRange:(NSString *)weaponRange
                    weaponExLine1:(NSString *)weaponExLine1
                    weaponExLine2:(NSString *)weaponExLine2;

@end
