//
//  UnitsByOriginViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/16/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitsByOriginViewController.h"
#import "GundamOrigin.h"

#import "GDManagerFactory.h"
#import "GDManager.h"

#import "UnitInfoShort.h"
#import "UnitViewController.h"

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
    
    self.unitsView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_honeycomb"]];
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
    self.originTitle = [[GundamOrigin originTitles] objectForKey:origin];
    self.navigationItem.title = [[GundamOrigin originShortTitles] objectForKey:origin];
    
    [self.manager fetchUnitsByOrigin:_origin];

}

- (GDManager *)manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    return _manager;
}

- (void)didReceiveUnitsOfOrigin:(NSArray *)unitsOfOrigin {
    units = unitsOfOrigin;
    
    [self.unitsView reloadData];
}

- (void)fetchUnitsByOriginWithError:(NSError *)error {
    [GDAppUtility alertError:error alertTitle:@"网络不给力啊"];
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
    
    cell.unitId = unit.unitId;
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

@end
