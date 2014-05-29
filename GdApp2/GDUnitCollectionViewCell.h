//
//  GDUnitCollectionViewCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/29/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDPostListCollectionViewCell.h"

@interface GDUnitCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *unitId;
@property (nonatomic) GDCVCellBorder border;

@end
