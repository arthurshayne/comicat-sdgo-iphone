//
//  OriginListViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "OriginListViewController.h"
#import "GundamOrigin.h"
#import "OriginTableViewCell.h"
#import "GDManager.h"
#import "GDManagerFactory.h"

@interface OriginListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *originListView;

@property (strong, nonatomic) NSDictionary *origins;
@property (strong, nonatomic) NSDictionary *unitCountByOrigin;

@property (strong, nonatomic) GDManager *manager;

@end

@implementation OriginListViewController

static const NSString *CELL_IDENTIFIER = @"OriginCell";
static const CGFloat CELL_HEIGHT = 98;

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory getGDManagerWithDelegate:self];
    }
    
    return _manager;
}

- (void)setUnitCountByOrigin:(NSDictionary *)unitCountByOrigin {
    _unitCountByOrigin = unitCountByOrigin;
    [self.originListView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.manager fetchUnitCountByOrigin];
    
    [self.originListView registerClass:[OriginTableViewCell class] forCellReuseIdentifier:[CELL_IDENTIFIER copy]];
    
    // bounce background color
    CGRect viewFrame = self.view.frame;
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, -viewFrame.size.height, viewFrame.size.width, viewFrame.size.height)];
    topview.backgroundColor = [UIColor blackColor];
    [self.originListView addSubview:topview];
    
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, [GundamOrigin origins].count * CELL_HEIGHT, viewFrame.size.width, viewFrame.size.height)];
    bottomview.backgroundColor = [UIColor blackColor];
    [self.originListView addSubview:bottomview];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OriginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CELL_IDENTIFIER copy]];
    if (cell) {
        [cell prepareForReuse];
        
        NSString *originIndex = [[GundamOrigin origins] objectAtIndex:indexPath.row];
        cell.originIndex = originIndex;
        if (self.unitCountByOrigin) {
            cell.unitCount = [[self.unitCountByOrigin objectForKey:originIndex] unsignedIntValue];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GundamOrigin origins].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - GDManagerDelegate
- (void)didReceiveUnitCountByOrigin:(NSDictionary *)unitCountByOrigin {
    self.unitCountByOrigin = unitCountByOrigin;
}

- (void)fetchUnitCountByOriginWithError:(NSError *)error {
    
}

@end
