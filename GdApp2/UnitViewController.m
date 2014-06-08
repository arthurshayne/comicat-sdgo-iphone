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
#import "UnitSkillCell.h"
#import "UnitWeaponCell.h"
#import "UnitMiscInfoCell.h"
#import "UnitGetwayCell.h"
#import "UnitStoryCell.h"

@interface UnitViewController ()

@property (strong, nonatomic) UnitInfo *unitInfo;
@property (weak, nonatomic) IBOutlet UITableView *rootTableView;

@property (strong, nonatomic) UnitBasicDataView *unitBasicDataView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) GDManager *manager;

//@property (nonatomic) BOOL viewDidAppear;
//@property (nonatomic) BOOL didReceiveUnitInfo;
//@property (nonatomic) BOOL animationPlayed;

@end

@implementation UnitViewController

- (UnitBasicDataView *)unitBasicDataView {
    if (!_unitBasicDataView) {
        _unitBasicDataView = [[UnitBasicDataView alloc] initWithFrame:CGRectMake(0, 8, 320, 168)];
    }
    return _unitBasicDataView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"武器", @"技能", @"资料", @"视频"]];
        _segmentedControl.frame = CGRectMake(10, 6, 300, 26);
        _segmentedControl.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        
        [_segmentedControl addTarget:self action:@selector(segmentSwitched:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
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
    [self.rootTableView registerClass:[UnitSkillCell class] forCellReuseIdentifier:@"Skill"];
    [self.rootTableView registerClass:[UnitWeaponCell class] forCellReuseIdentifier:@"Weapon"];
    [self.rootTableView registerClass:[UnitMiscInfoCell class] forCellReuseIdentifier:@"Misc"];
    [self.rootTableView registerClass:[UnitStoryCell class] forCellReuseIdentifier:@"Story"];
    [self.rootTableView registerClass:[UnitGetwayCell class] forCellReuseIdentifier:@"Getway"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager fetchUnitInfo:self.unitId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.viewDidAppear = YES;
//    if (!self.animationPlayed && self.didReceiveUnitInfo) {
//        NSLog(@"play animation viewDidAppear");
//        [self.unitBasicDataView playAnimations];
//        self.animationPlayed = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GDManagerDelegate

- (void)didReceiveUnitInfo:(UnitInfo *)unitInfo {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.unitInfo = unitInfo;
    
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
    
//    if (self.viewDidAppear && !self.animationPlayed) {
//        NSLog(@"play animation didReceiveUnitInfo");
//        [self.unitBasicDataView playAnimations];
//        self.animationPlayed = YES;
//    }
    
    [self.unitBasicDataView playAnimations];
}

- (void)fetchUnitInfoWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"网络连接"
                                                    message: [error localizedDescription]
                                                   delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)segmentSwitched:(UISegmentedControl *)segment {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:1];
    [UITableView setAnimationsEnabled:NO];
    [self.rootTableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
    [UITableView setAnimationsEnabled:YES];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 30 /* for segmented control*/;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Basic
        return 176; /* with padding*/
    } else if (indexPath.section == 1) {
        switch(self.segmentedControl.selectedSegmentIndex) {
            case 0:
                // weapons
                return [self heightForWeaponAtIndex:indexPath.row];
            case 1:
                // skill
                return [self heightForSkillAtIndex:indexPath.row];
            case 2:
                // misc1, story, getway
                return [self heightForMiscAtIndex:indexPath.row];
        }
    }
    
    return 0;
}

- (CGFloat)heightForSkillAtIndex:(NSUInteger)index {
    u_long indexPlus1 = index + 1;
    
    NSString *skillName = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"skillName%lu", indexPlus1]];
    NSString *skillDesc = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"skillDesc%lu", indexPlus1]];
    NSString *skillEx = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"skillEx%lu", indexPlus1]];
    
    return [UnitSkillCell calculateCellHeightForSkillName:skillName skillDesc:skillDesc skillEx:skillEx];
}

- (CGFloat)heightForWeaponAtIndex:(NSUInteger)index {
    uint weaponIndex = (uint)(index + 1);
    NSString *weaponName = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponName%u", weaponIndex]];
    NSString *weaponProperty = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponProperty%u", weaponIndex]];
    NSString *weaponEffect = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponEffect%u", weaponIndex]];
    NSString *weaponRange = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponRange%u", weaponIndex]];
    NSString *weaponExLine1 = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponEx%uLine1", weaponIndex]];
    NSString *weaponExLine2 = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponEx%uLine2", weaponIndex]];
    
    return [UnitWeaponCell calculateCellHeightFor:weaponIndex
                                       weaponName:weaponName
                                     weaponEffect:weaponEffect
                                   weaponProperty:weaponProperty
                                      weaponRange:weaponRange
                                    weaponExLine1:weaponExLine1
                                    weaponExLine2:weaponExLine2];
}

- (CGFloat)heightForMiscAtIndex:(NSUInteger)index {
    switch(index) {
        case 0:
            // misc
            return [UnitMiscInfoCell calculateHeightForUnit:self.unitInfo];
        case 1:
            // story
            return [UnitStoryCell calculateHeight:self.unitInfo.story];
        case 2:
            // getway
            return [UnitGetwayCell calculateHeightForUnit:self.unitInfo];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.unitInfo) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.unitInfo) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            switch(self.segmentedControl.selectedSegmentIndex) {
                case 0:
                    return self.unitInfo.numberOfWeapons;
                case 1:
                    // skills
                    return 3;
                case 2:
                    // misc, story, getway
                    return 3;
                case 3:
                    // video;
                    return 0;
            }
        }
    } else {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *identifier = indexPath.section == 0 ? @"Basic" : @"Extended";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//;
    if (indexPath.section == 0) {
        // Basic Info
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Basic"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.unitBasicDataView];
        return cell;
    } else if (indexPath.section == 1) {
        switch(self.segmentedControl.selectedSegmentIndex) {
            case 0:
                // weapon
                return [self tableView:tableView cellForWeaponAtIndex:indexPath.row];
                break;
            case 1:
                // skill
                return [self tableView:tableView cellForSkillAtIndex:indexPath.row];
            case 2:
                // other
                return [self tableView:tableView cellForMiscAtIndex:indexPath.row];
            default:
                return [tableView dequeueReusableCellWithIdentifier:@"Basic"];
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSkillAtIndex:(NSUInteger)index {
    UnitSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Skill"];
    
    u_long indexPlus1 = index + 1;
    
    id skillId = [self.unitInfo valueForKey:[NSString stringWithFormat:@"skill%lu", indexPlus1]];
    NSString *skillName = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"skillName%lu", indexPlus1]];
    NSString *skillDesc = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"skillDesc%lu", indexPlus1]];
    NSString *skillEx = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"skillEx%lu", indexPlus1]];
    
    [cell setValue:skillId forKey:@"skillId"];
    cell.skillName = skillName;
    cell.skillDesc = skillDesc;
    cell.skillEx = skillEx;
    
    [cell updateSkillText];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForWeaponAtIndex:(NSUInteger)index {
    UnitWeaponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Weapon"];
    
    uint weaponIndex = (uint)(index + 1);
    id weaponId = [self.unitInfo valueForKey:[NSString stringWithFormat:@"weapon%u", weaponIndex]];
    NSString *weaponName = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponName%u", weaponIndex]];
    NSString *weaponProperty = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponProperty%u", weaponIndex]];
    NSString *weaponEffect = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponEffect%u", weaponIndex]];
    NSString *weaponRange = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponRange%u", weaponIndex]];
    NSString *weaponExLine1 = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponEx%uLine1", weaponIndex]];
    NSString *weaponExLine2 = (NSString *)[self.unitInfo valueForKey:[NSString stringWithFormat:@"weaponEx%uLine2", weaponIndex]];

    [cell setValue:weaponId forKey:@"weaponId"];
    cell.weaponIndex = weaponIndex;
    cell.weaponName = weaponName;
    cell.weaponProperty = weaponProperty;
    cell.weaponEffect = weaponEffect;
    cell.weaponRange = weaponRange;
    cell.weaponExLine1 = weaponExLine1;
    cell.weaponExLine2 = weaponExLine2;
    
    [cell updateWeaponText];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMiscAtIndex:(NSUInteger)index {
    switch (index) {
        case 0: {
            UnitMiscInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Misc"];
            cell.unit = self.unitInfo;
            return cell;
        }
        case 1: {
            UnitStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Story"];
            cell.story = self.unitInfo.story;
            return cell;
        }
        case 2: {
            UnitGetwayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Getway"];
            cell.unit = self.unitInfo;
            return cell;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        [viewForHeader addSubview:self.segmentedControl];
        viewForHeader.backgroundColor = [UIColor whiteColor];
        return viewForHeader;
    }
    return nil;
}

@end
