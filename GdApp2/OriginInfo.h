//
//  OriginInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/18/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OriginInfo : NSObject

@property (strong, nonatomic) NSString *originIndex;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *shortTitle;
@property (nonatomic) uint numberOfUnits;

+ (OriginInfo *)originWithOriginIndex:(NSString *)originIndex title:(NSString *)title shortTitle:(NSString *)shortTitle numberOfUnits:(uint)numberOfUnits;

+ (NSArray *)builtInOrigins;

@end
