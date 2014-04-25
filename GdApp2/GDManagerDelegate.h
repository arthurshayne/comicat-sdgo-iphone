//
//  SdgundamManagerDelegate.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/24/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeInfo.h"

@protocol GDManagerDelegate <NSObject>
- (void)didReceiveHomeInfo:(HomeInfo *)homeInfo;
- (void)fetchingHomeInfoWithError:(NSError *)error;
@end
