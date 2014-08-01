//
//  UnitMixMaterialView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/31/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitMixMaterial.h"

typedef enum : NSUInteger {
    UMMDIsplayTypeMixMaterials,    // mix materials
    UMMDIsplayTypeCanMixAsKey,    // can be used as key
    UMMDIsplayTypeCanMixAsMaterial,    // can be used as material
} UMMDIsplayType;

@interface UnitMixMaterialView : UIView

@property (strong, nonatomic) UnitMixMaterial *umm;
@property (nonatomic) BOOL isKeyUnit;

@property (nonatomic) UMMDIsplayType displayType;

@end
