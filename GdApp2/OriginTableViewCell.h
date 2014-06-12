//
//  OriginTableViewCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface OriginTableViewCell : ABTableViewCell {
    NSString *originTitle;
    NSString *originShortTitle;
    UIImage *originImage;
    NSAttributedString *unitCountAttrStr;
}

@property (nonatomic, strong) NSString *originIndex;
@property (nonatomic) uint unitCount;
@end