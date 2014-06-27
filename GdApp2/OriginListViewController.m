//
//  OriginListViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "OriginListViewController.h"
#import "OriginTableViewCell.h"

#import "GDManager.h"
#import "GDManagerFactory.h"

#import "UnitsByOriginViewController.h"

#import "OriginInfo.h"

@interface OriginListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *originListView;

@property (strong, nonatomic) NSArray *origins;
// @property (strong, nonatomic) NSDictionary *unitCountByOrigin;

@property (strong, nonatomic) GDManager *manager;

@end

@implementation OriginListViewController

static const NSString *CELL_IDENTIFIER = @"OriginCell";
static const CGFloat CELL_HEIGHT = 98;

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    
    return _manager;
}

- (NSArray *)origins {
    if (!_origins) {
        _origins = [[self.manager getUnitOrigins] copy];
    }
    return _origins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.originListView registerClass:[OriginTableViewCell class] forCellReuseIdentifier:[CELL_IDENTIFIER copy]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_honeycomb"]];
    
    // bounce background color
//    CGRect viewFrame = self.view.frame;
//    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, -viewFrame.size.height, viewFrame.size.width, viewFrame.size.height)];
//    topview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_honeycomb"]];
//    [self.originListView addSubview:topview];
//    
//    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, self.origins.count * CELL_HEIGHT, viewFrame.size.width, viewFrame.size.height)];
//    bottomview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_honeycomb"]];
//    [self.originListView addSubview:bottomview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"作品列表"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"作品列表"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewUnitsByOrigin"]) {
        if ([segue.destinationViewController isKindOfClass:[UnitsByOriginViewController class]]) {
            UnitsByOriginViewController *ubovc = (UnitsByOriginViewController *)segue.destinationViewController;
            ubovc.origin = segueingOrigin.originIndex;
            ubovc.originShortTitle = segueingOrigin.shortTitle;
            ubovc.hidesBottomBarWhenPushed = YES;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OriginInfo *origin = (OriginInfo *)[self.origins objectAtIndex:indexPath.row];
    segueingOrigin = origin;
    
    [self performSegueWithIdentifier:@"ViewUnitsByOrigin" sender:self];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OriginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CELL_IDENTIFIER copy]];
    
    if (cell) {
        [cell prepareForReuse];
        
        OriginInfo *origin = (OriginInfo *)[self.origins objectAtIndex:indexPath.row];
        cell.originIndex = origin.originIndex;
        cell.originTitle = origin.title;
        cell.unitCount = origin.numberOfUnits;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.origins.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
