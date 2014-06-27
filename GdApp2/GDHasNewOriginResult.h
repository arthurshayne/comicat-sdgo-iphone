//
//  GDHasNewOriginResult.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/26/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDHasNewOriginResult : NSObject

@property (nonatomic) BOOL result;
@property (nonatomic, strong) NSArray *origins; // of key:NSString value:OriginInfo

@end
