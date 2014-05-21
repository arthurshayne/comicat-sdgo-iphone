//
//  GDVideoListDSDelegate.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/20/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDVideoListDSDelegate <NSObject>

- (void)dataDidPrepared:(NSUInteger)numberOfNewItems previouslyHave:(NSUInteger)numberOfOldItems ofGDCategory:(uint)gdCategory needToReload:(BOOL)reload;
- (void)dataSourceWithError:(NSError *)error;
- (void)noMoreDataFromGDCategory:(unsigned int)gdCategory;
- (void)willLoadDataFromGDCategory:(unsigned int)gdCategory isReloading:(BOOL)reloading;
@end
