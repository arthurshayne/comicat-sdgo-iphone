//
//  UnitViewController.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/10/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDManagerDelegate.h"

@interface UnitViewController : UIViewController <GDManagerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    int postIdForSegue;
}

@property (strong, nonatomic) NSString *unitId;

@end
