//
//  PushNoAnimationSegue.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/11/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue
-(void) perform {
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}
@end
