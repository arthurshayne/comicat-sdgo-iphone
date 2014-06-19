//
//  GDHome2ViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 4/22/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GBInfiniteScrollView.h>
#import "GDManager.h"

@interface GDHome2ViewController : UIViewController <GBInfiniteScrollViewDataSource, GBInfiniteScrollViewDelegate,
GDManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    NSDate *lastPullToRefresh;
    int postIdForSegue;
    NSString *unitIdForSegue;
}

@end
