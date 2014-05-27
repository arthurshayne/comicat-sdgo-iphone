//
//  GDPostListCVCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/26/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostInfo.h"

typedef NS_OPTIONS(NSUInteger, GDCVCellBorder) {
    GDCVCellBorderNone      = 1 << 0,
    GDCVCellBorderTop       = 1 << 1,
    GDCVCellBorderRight     = 1 << 2,
    GDCVCellBorderBottom    = 1 << 3,
    GDCVCellBorderLeft      = 1 << 4
};

@interface GDPostListCollectionViewCell : UICollectionViewCell

@property (nonatomic) GDCVCellBorder border;

- (void)configureForPostInfo:(PostInfo *)post;

@end
