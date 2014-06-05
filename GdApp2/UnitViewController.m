//
//  UnitViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/10/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitViewController.h"

#import "MBProgressHUD.h"

#import "GDManager.h"
#import "GDManagerFactory.h"

#import "UnitInfo.h"

#import "UnitBasicDataView.h"

@interface UnitViewController ()

@property (strong, nonatomic) UnitInfo *unitInfo;
@property (weak, nonatomic) IBOutlet UITableView *rootTableView;

@property (strong, nonatomic) UnitBasicDataView *unitBasicDataView;

@property (strong, nonatomic) GDManager *manager;

@property (nonatomic) BOOL viewDidAppear;
@property (nonatomic) BOOL animationPlayed;

@end

@implementation UnitViewController

- (UnitBasicDataView *)unitBasicDataView {
    if (!_unitBasicDataView) {
        _unitBasicDataView = [[UnitBasicDataView alloc] initWithFrame:CGRectMake(0, 8, 320, 168)];
    }
    return _unitBasicDataView;
}

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory getGDManagerWithDelegate:self];
    }
    
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Basic"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager fetchUnitInfo:self.unitId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.viewDidAppear = YES;
    if (!self.animationPlayed) {
        [self.unitBasicDataView playAnimations];
        self.animationPlayed = YES;
    }
    
    NSLog(@"viewDidAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GDManagerDelegate

- (void)didReceiveUnitInfo:(UnitInfo *)unitInfo {
    // setup basic data view
    self.unitBasicDataView.modelName = unitInfo.modelName;
    self.unitBasicDataView.unitId = unitInfo.unitId;
    self.unitBasicDataView.attackValue = unitInfo.attackG;
    self.unitBasicDataView.defenseValue = unitInfo.defenseG;
    self.unitBasicDataView.mobilityValue = unitInfo.mobilityG;
    self.unitBasicDataView.controlValue = unitInfo.controlG;
    self.unitBasicDataView.sum3DValue = unitInfo.sum3D;
    self.unitBasicDataView.sum4DValue = unitInfo.sum4D;
    self.unitBasicDataView.rank = unitInfo.rank;
    
    [self.rootTableView reloadData];
    
    if (self.viewDidAppear && !self.animationPlayed) {
        [self.unitBasicDataView playAnimations];
        self.animationPlayed = YES;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)fetchUnitInfoWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"网络连接"
                                                    message: [error localizedDescription]
                                                   delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 44 /* for segmented control*/;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Basic
        return 176; /* with padding*/
    }
    
    return 0;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    } else if (section == 1) {
//        return 1;
//    }
//    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.section == 0 ? @"Basic" : @"Extended";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell) {
        if (indexPath.section == 0) {
            // Basic Info
            [cell.contentView addSubview:self.unitBasicDataView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // customize cell
    return cell;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section == 1) {
//        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"技能", @"武器", @"基本"]];
//        segmentedControl.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
//        
//        return segmentedControl;
//    }
//    return nil;
//}


@end
