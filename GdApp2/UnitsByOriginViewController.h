//
//  UnitsByOriginViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDManagerDelegate.h"

@interface UnitsByOriginViewController : UIViewController <GDManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *units;
    NSString *unitIdForSegue;
    NSDate *lastPullToRefresh;
}

@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSString *originShortTitle;

@end
