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
    UIImage *originImage;
}

@property (nonatomic, strong) NSString *originIndex;

@end
