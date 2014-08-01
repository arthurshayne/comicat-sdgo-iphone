//
//  UnitMixView.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 7/30/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitMixMaterial.h"

@interface UnitMixPopupView : UIView

- (id) initWithKeyUnit:(UnitMixMaterial *)keyUnit
           materialUnits:(NSArray *)materialUnits;

@property (strong, nonatomic) NSString *caption;

@property (nonatomic, copy) void (^dismissWithClickOnUnit)(NSString *);

@end
