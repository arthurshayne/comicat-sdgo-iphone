//
//  GDInfoBuilder.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeInfo.h"

@interface GDInfoBuilder : NSObject
+ (HomeInfo *) homeInfoFromJSON: (NSData *)objectNotation error:(NSError **)error;
@end
