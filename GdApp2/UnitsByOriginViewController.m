//
//  UnitsByOriginViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitsByOriginViewController.h"

#import "MBProgressHUD.h"
#import "UIScrollView+GDPullToRefresh.h"
#import "SVPullToRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "GDManagerFactory.h"
#import "GDManager.h"

#import "UnitInfoShort.h"
#import "UnitViewController.h"
#import "OriginInfo.h"

#import "GDUnitCollectionViewCell2.h"

@interface UnitsByOriginViewController()

@property (strong, nonatomic) NSString *originTitle;

@property (strong, nonatomic) GDManager *manager;

@property (weak, nonatomic) IBOutlet UICollectionView *unitsView;

@end

@implementation UnitsByOriginViewController

static const NSString *CELL_IDENTIFIER = @"UnitCell";

- (void)viewDidLoad {
    [self.unitsView registerClass:[GDUnitCollectionViewCell2 class] forCellWithReuseIdentifier:[CELL_IDENTIFIER copy]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_honeycomb"]];
    
    [self configurePullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"机体按作品"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"机体按作品"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ViewUnit"]) {
        if ([segue.destinationViewController isKindOfClass:[UnitViewController class]]) {
            UnitViewController *uvc = (UnitViewController *)segue.destinationViewController;
            uvc.unitId = unitIdForSegue;
        }
    }
}

- (void)setOrigin:(NSString *)origin {
    _origin = origin;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    [self.manager fetchUnitsByOrigin:origin force:NO];
}

- (void)setOriginShortTitle:(NSString *)originShortTitle {
    _originShortTitle =  originShortTitle;
    self.navigationItem.title = originShortTitle;
}

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    return _manager;
}

- (void)didReceiveUnitList:(UnitList *)list ofOrigin:(NSString *)origin {
    [self stopAllLoadingAnimations];
    units = list.units;
    
    [self.unitsView reloadData];
}

- (void)fetchUnitsByOriginWithError:(NSError *)error {
    [self stopAllLoadingAnimations];
    [GDAppUtility alertError:error alertTitle:@"数据加载失败"];
}

- (void)configurePullToRefresh {
    [self.unitsView addGDPullToRefreshWithActionHandler:^{
        BOOL shouldForce = lastPullToRefresh && fabs([lastPullToRefresh timeIntervalSinceNow]) < 10;
        [self.manager fetchUnitsByOrigin:self.origin force:shouldForce];
        if (shouldForce) {
            lastPullToRefresh = nil;
        } else {
            lastPullToRefresh = [NSDate date];
        }
        
    }];
}

- (void)stopAllLoadingAnimations {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.unitsView.pullToRefreshView stopAnimating];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return units.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UnitInfo *unit = (UnitInfo *)[units objectAtIndex:indexPath.row];
    
    GDUnitCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CELL_IDENTIFIER copy] forIndexPath:indexPath];
    
    [cell prepareForReuse];

    if (!collectionView.isDecelerating) {
        cell.unitId = unit.unitId;
    }
    
    cell.modelName = unit.modelName;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        UnitInfoShort *uis = [units objectAtIndex: indexPath.row];
        unitIdForSegue = uis.unitId;
        
        [self performSegueWithIdentifier:@"ViewUnit" sender:self];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)view layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 135);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleIndexPaths = [self.unitsView indexPathsForVisibleItems];
    [visibleIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        UnitInfo *unit = (UnitInfo *)[units objectAtIndex:indexPath.row];
        
        GDUnitCollectionViewCell2 *cell = (GDUnitCollectionViewCell2 *)[self.unitsView cellForItemAtIndexPath:indexPath];
        cell.unitId = unit.unitId;
    }];
}

@end
