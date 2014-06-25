//
//  OriginTableViewCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface OriginTableViewCell : UITableViewCell {
    UIImage *originImage;
    NSAttributedString *unitCountAttrStr;
    
    UIView *contentView;
}

@property (nonatomic, strong) NSString *originIndex;
@property (nonatomic, strong) NSString *originTitle;
@property (nonatomic) uint unitCount;

- (void)drawContentView:(CGRect)rect;
@end