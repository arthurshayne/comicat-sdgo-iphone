//
//  UnitViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/10/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDManagerDelegate.h"
#import "GDTMobBannerView.h" 

@interface UnitViewController : UIViewController <GDManagerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GDTMobBannerViewDelegate> {
    int postIdForSegue;
    NSDate *lastPullToRefresh;
    
    BOOL isUmpvPreviouslyOpened;
    BOOL isUmpvCNPreviouslyOpened;
}

@property (strong, nonatomic) NSString *unitId;

@end
