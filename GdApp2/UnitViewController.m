//
//  UnitViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/10/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitViewController.h"

#import "MBProgressHUD.h"
#import "UIScrollView+GDPullToRefresh.h"
#import "SVPullToRefresh.h"
#import "GDPopupView.h"
#import "UMSocial.h"

#import "UIViewController+NavigationMax3.h"

#import "GDManager.h"
#import "GDManagerFactory.h"
#import "UnitService.h"
#import "GDEasterEgg.h"

#import "UnitInfo.h"

#import "UnitBasicDataView.h"
#import "UnitSkillCell.h"
#import "UnitWeaponCell.h"
#import "UnitMiscInfoCell.h"
#import "UnitGetwayCell.h"
#import "UnitStoryCell.h"
#import "GDVideoListCollectionViewCell.h"
#import "NetworkErrorView.h"
#import "UnitMixPopupView.h"
#import "GundamStyleBorderedButton.h"

#import "GDVideoViewController.h"

@interface UnitViewController ()

@property (strong, nonatomic) UnitInfo *unitInfo;
@property (weak, nonatomic) IBOutlet UITableView *rootTableView;

@property (nonatomic, strong) GDPopupView *popup;

@property (strong, nonatomic) UnitBasicDataView *unitBasicDataView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UICollectionView *videoListView;
@property (strong, nonatomic) UILabel *noVideoLabel;

@property (strong, nonatomic) GDTMobBannerView *bannerView;

@property (strong, nonatomic) GDManager *manager;

@end

@implementation UnitViewController

static const NSString *CELL_IDENTIFIER = @"VideoListViewCell";

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

- (UICollectionView *)videoListView {
    if (!_videoListView) {
        NSString *cellIdentifier = [CELL_IDENTIFIER copy];
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;

        _videoListView = [[UICollectionView alloc] initWithFrame:CGRectMake(6, 8, 308, 454) collectionViewLayout:flow];
        _videoListView.backgroundColor = [UIColor clearColor];
        _videoListView.opaque = YES;
        _videoListView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        
        [_videoListView registerClass:[GDVideoListCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        _videoListView.dataSource = self;
        _videoListView.delegate = self;
        
        _videoListView.bounces = NO;
        _videoListView.scrollEnabled = NO;
    }
    
    return _videoListView;
}

- (UILabel *)noVideoLabel {
    if (!_noVideoLabel) {
        _noVideoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
        _noVideoLabel.textAlignment = NSTextAlignmentCenter;
        _noVideoLabel.text = @"咋没有视频呢...快去网站上投个稿吧!";
        _noVideoLabel.font = [UIFont systemFontOfSize:16];
        _noVideoLabel.textColor = [UIColor grayColor];
    }
    return _noVideoLabel;
}

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    
    return _manager;
}

- (GDTMobBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 36,
                                                                         GDTMOB_AD_SIZE_320x50.width,
                                                                         GDTMOB_AD_SIZE_320x50.height)
                                                       appkey:@"1101753730"
                                                  placementId:@"9079537215720143139"];
        
        _bannerView.delegate = self; // 设置Delegate
        _bannerView.currentViewController = self; //设置当前的ViewController
        _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
        
        [_bannerView loadAdAndShow];
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Basic"];
    [self.rootTableView registerClass:[UnitSkillCell class] forCellReuseIdentifier:@"Skill"];
    [self.rootTableView registerClass:[UnitWeaponCell class] forCellReuseIdentifier:@"Weapon"];
    [self.rootTableView registerClass:[UnitMiscInfoCell class] forCellReuseIdentifier:@"Misc"];
    [self.rootTableView registerClass:[UnitStoryCell class] forCellReuseIdentifier:@"Story"];
    [self.rootTableView registerClass:[UnitGetwayCell class] forCellReuseIdentifier:@"Getway"];
    [self.rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"VideoList"];
    [self.rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Common"];
    
    [self configurePullToRefresh];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.manager fetchUnitInfo:self.unitId force:NO];
    
    // eliminate extra separators
    self.rootTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self configureNavigationMax3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"机体详细"];
    
    if (isUmpvPreviouslyOpened) {
        [self showUnitMixPopup];
    } else if (isUmpvCNPreviouslyOpened) {
        [self showUnitMixPopupCN];
    }
    isUmpvCNPreviouslyOpened = isUmpvCNPreviouslyOpened = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"机体详细"];
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

- (void)configurePullToRefresh {
    [self.rootTableView addGDPullToRefreshWithActionHandler:^{
        BOOL shouldForce = lastPullToRefresh && fabs([lastPullToRefresh timeIntervalSinceNow]) < 10;
        [self.manager fetchUnitInfo:self.unitId force:shouldForce];
        if (shouldForce) {
            lastPullToRefresh = nil;
        } else {
            lastPullToRefresh = [NSDate date];
        }
    }];
}

- (void)stopAllLoadingAnimations {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.rootTableView.pullToRefreshView stopAnimating];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewVideo"]) {
        if ([segue.destinationViewController isKindOfClass:[GDVideoViewController class]]) {
            GDVideoViewController *gdpvc = (GDVideoViewController *)segue.destinationViewController;
            gdpvc.postId = postIdForSegue;
            gdpvc.fromUnitId = self.unitId;
            gdpvc.hidesBottomBarWhenPushed = YES;
        }
    }
}

#pragma mark - GDManagerDelegate

- (void)didReceiveUnitInfo:(UnitInfo *)unitInfo {
    [NetworkErrorView hideNEVForView:self.view];
    
    [self stopAllLoadingAnimations];
    
    self.unitInfo = unitInfo;
    
    // NSLog([NSString stringWithFormat:@"%d", [UnitService areUnitsAllViewed:@[@"15011", @"15001"]]]);
    [UnitService markUnitViewed:self.unitId];
    [GDEasterEgg proceedEasterEggDiscovery:self.unitId];
    
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
    
    if (self.unitInfo.videoList.count > 0) {
        CGRect videoListFrame = self.videoListView.frame;
        videoListFrame.size.height = 135 * (int)((self.unitInfo.videoList.count + 1) / 2);
        self.videoListView.frame = videoListFrame;
        
        [self.videoListView reloadData];
    }
    
    [self.rootTableView reloadData];

    [self.unitBasicDataView playAnimations];
}

- (void)fetchUnitInfoWithError:(NSError *)error {
    [self stopAllLoadingAnimations];
    
    if (!self.unitInfo && [GDAppUtility isViewDisplayed:self.view]) {
        [GDAppUtility alertError:error alertTitle:@"数据加载失败"];
    }
    
    if (!self.unitInfo) {
        [NetworkErrorView showNEVAddTo:self.view reloadCallback:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.manager fetchUnitInfo:self.unitId force:NO];
        }];
    }
}

- (void)segmentSwitched:(UISegmentedControl *)segment {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:1];
    [UITableView setAnimationsEnabled:NO];
    [self.rootTableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
    [UITableView setAnimationsEnabled:YES];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 90 /* for segmented control*/;
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
                // misc, mix, story, getway
                return [self heightForMiscAtIndex:indexPath.row];
            case 3:
                if (self.unitInfo.videoList.count > 0) {
                    return self.videoListView.frame.size.height;
                } else {
                    return 60;
                }
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
            // mix, if any
            return self.unitInfo.mixingKeyUnit ? 75 : 0;
        case 2:
            // story
            return [UnitStoryCell calculateHeight:self.unitInfo.story];
        case 3:
            // getway
            return [UnitGetwayCell calculateHeightForUnit:self.unitInfo];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
        }
    }
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
                case 2: {
                    // misc, mix, story, getway
                    return 4;
                }
                case 3:
                    // video;
                    return 1;
            }
        }
    } else {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Basic Info
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Basic"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.unitBasicDataView];
        cell.userInteractionEnabled = NO;
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
                // misc
                return [self tableView:tableView cellForMiscAtIndex:indexPath.row];
            case 3: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoList"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.unitInfo.videoList.count > 0) {
                    [cell.contentView addSubview:self.videoListView];
                } else {
                    [cell.contentView addSubview:self.noVideoLabel];
                }
                return cell;
            }
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
    
    cell.userInteractionEnabled = NO;
    
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
    
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMiscAtIndex:(NSUInteger)index {
    switch (index) {
        case 0: {
            UnitMiscInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Misc"];
            cell.unit = self.unitInfo;
            cell.userInteractionEnabled = NO;
            return cell;
        }
        case 1: {
            // mix
            return [self cellForUnitMixOnTableView:tableView];
        }
        case 2: {
            UnitStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Story"];
            
            cell.story = self.unitInfo.story;
            cell.userInteractionEnabled = NO;
            return cell;
        }
        case 3: {
            UnitGetwayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Getway"];
            cell.unit = self.unitInfo;
            cell.userInteractionEnabled = NO;
            return cell;
        }
    }
    return nil;
}

- (UITableViewCell *)cellForUnitMixOnTableView:(UITableView *)tableView  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Common"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Common"];
    }
    
    // fixes text overlaps to the cell below
    cell.clipsToBounds = YES;
    
    UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 8, 120, 24)];
    captionLabel.font = [UIFont systemFontOfSize:15];
    captionLabel.text = @"合成";
    
    [cell.contentView addSubview:captionLabel];
    
    if (self.unitInfo.mixingKeyUnit) {
        GundamStyleBorderedButton *mixButton = [[GundamStyleBorderedButton alloc] initWithFrame:CGRectMake(33, 40, 100, 24)];
        mixButton.cutCorners = CutCornerNW | CutCornerSE | CutCornerSW | CutCornerNE;
        mixButton.cutCornerSize = 12;
        [mixButton setTitle:@"查看" forState:UIControlStateNormal];
        mixButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [mixButton setTitleColor:[GDAppUtility appTintColor] forState:UIControlStateNormal];
//        [mixButton setTitleColor:[GDAppUtility appTintColorHighlighted] forState:UIControlStateHighlighted];
        [mixButton addTarget:self action:@selector(showUnitMixPopup) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:mixButton];
    }
    
    if (self.unitInfo.mixingKeyUnitCN) {
        GundamStyleBorderedButton *mixButton = [[GundamStyleBorderedButton alloc] initWithFrame:CGRectMake(160, 40, 130, 24)];
        mixButton.cutCorners = CutCornerNW | CutCornerSE | CutCornerSW | CutCornerNE;
        mixButton.cutCornerSize = 12;
        [mixButton setTitle:@"查看国服" forState:UIControlStateNormal];
        mixButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [mixButton setTitleColor:[GDAppUtility appTintColor] forState:UIControlStateNormal];
        // [mixButton setTitleColor:[GDAppUtility appTintColorHighlighted] forState:UIControlStateHighlighted];
        [mixButton addTarget:self action:@selector(showUnitMixPopupCN) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:mixButton];
    }
    
    return cell;
}

- (void)showUnitMixPopup {
    UnitMixPopupView *view = [[UnitMixPopupView alloc] initWithKeyUnit:self.unitInfo.mixingKeyUnit
                                                           materialUnits:self.unitInfo.mixingMaterialUnits];
    view.caption = @"合成需求";

    self.popup = [GDPopupView popupWithView:view];
    self.popup.hideOnBackgroundTap = YES;
    
    [self.popup show];

    view.dismissWithClickOnUnit = ^void(NSString *unitId) {
        [self.popup hide];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isUmpvPreviouslyOpened = YES;
            [self presentUnitView:unitId];
        });
    };
}

- (void)showUnitMixPopupCN {
    UnitMixPopupView *view = [[UnitMixPopupView alloc] initWithKeyUnit:self.unitInfo.mixingKeyUnitCN
                                                         materialUnits:self.unitInfo.mixingMaterialUnitsCN];
    view.caption = @"国服合成需求";
    
    self.popup = [GDPopupView popupWithView:view];
    self.popup.hideOnBackgroundTap = YES;
    [self.popup show];
    
    view.dismissWithClickOnUnit = ^void(NSString *unitId) {
        [self.popup hide];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isUmpvCNPreviouslyOpened = YES;
            [self presentUnitView:unitId];
        });
    };
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        [viewForHeader addSubview:self.segmentedControl];
        
        [viewForHeader addSubview:self.bannerView];
        
        viewForHeader.backgroundColor = [UIColor whiteColor];
        return viewForHeader;
    }
    return nil;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.unitInfo.videoList.count;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [CELL_IDENTIFIER copy];
    
    GDVideoListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    VideoListItem *vli = (VideoListItem*)[self.unitInfo.videoList objectAtIndex:indexPath.row];
    
    if (vli) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.videoListItem = vli;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoListItem *vli = (VideoListItem*)[self.unitInfo.videoList objectAtIndex:indexPath.row];
    postIdForSegue = vli.postId;
    
    [self performSegueWithIdentifier:@"ViewVideo" sender:self];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 135);
}

- (void)presentUnitView:(NSString *)unitId {
    UnitViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitViewController"];
    uvc.unitId = unitId;
    
    [self.navigationController pushViewController:uvc animated:YES];
}


- (IBAction)shareButtonPressed:(id)sender {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.title = @"漫猫SD敢达iPhone";
    [UMSocialData defaultData].extConfig.wechatSessionData.url =
        [NSString stringWithFormat:@"http://www.sdgundam.cn/pages/app/iphone-landing-page.aspx?appurl=gdapp2://unit/%@", self.unitId];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:[NSString stringWithFormat:@"我正在用漫猫SD敢达App查看\"%@\"的详细资料和最新视频", self.unitInfo.modelName]
                                     shareImage:[UIImage imageNamed:@"AppIcon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToSms, UMShareToWechatTimeline, UMShareToWechatSession, nil]
                                       delegate:nil];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)     {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark - Others

- (void)markViewedUnit:(NSString *)unitId {
    
}

@end
