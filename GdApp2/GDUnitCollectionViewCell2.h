//
//  UnitCollectionViewCell.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>

// This is used on UnitsByOrigin view
@interface GDUnitCollectionViewCell2 : UICollectionViewCell

@property (strong, nonatomic) NSString *unitId;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *rank;

@property (nonatomic) BOOL showRemoteImage;

@end
