//
//  UnitList.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/17/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitList : NSObject

@property (strong, nonatomic) NSDate *generated;
@property (strong, nonatomic) NSArray *units;   // Array of UnitInfoShort

// optional
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSString *searchKeyword;

@end
