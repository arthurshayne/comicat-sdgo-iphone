//
//  SearchUnitViewController.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/5/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "SearchUnitViewController.h"
#import "UnitViewController.h"

#import "GDManager.h"
#import "GDManagerFactory.h"

#import "UnitInfoShort.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchUnitViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *units;
@property (strong, nonatomic) GDManager *manager;

@end

@implementation SearchUnitViewController

NSTimer *searchDelayer;
NSString *unitIdForSegue;

- (GDManager *) manager {
    if (!_manager) {
        _manager = [GDManagerFactory gdManagerWithDelegate:self];
    }
    
    return _manager;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewUnit"]) {
        if ([segue.destinationViewController isKindOfClass:([UnitViewController class])]) {
            if (unitIdForSegue.length > 0) {
                UnitViewController *uvc = (UnitViewController *)segue.destinationViewController;
                uvc.unitId = unitIdForSegue;
            }
        }
    }
}


#pragma mark - UIViewController
- (void)viewDidLoad {
    NSLog(@"%@", self.view.window);
    [super viewDidLoad];
    
    self.units = [NSArray arrayWithObjects:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"搜索机体"];
    [self.searchBar becomeFirstResponder];
    
    if (!self.tableView.delegate) {
        self.tableView.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.delegate = nil;
    
    [MobClick endLogPageView:@"搜索机体"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search units remotely
- (void)searchUnitsWithKeyword:(NSString *)keyword {
    if (keyword.length > 0) {
        [self.manager searchUnitsWithKeyword:keyword];
    } else {
        self.units = [NSArray arrayWithObjects:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - GDManagerDelegate

- (void)didReceiveUnitSearchResults:(NSArray *)units {
    self.units = units;
    
    [self.tableView reloadData];
}

- (void)searchUnitsWithError:(NSError *)error {
    [GDAppUtility alertError:error alertTitle:@"数据加载失败"];
}

#pragma mark - TableViewDelegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.units.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"UnitListTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }

    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UnitInfoShort *u = [self.units objectAtIndex:indexPath.row];

    // modelname
    UILabel *modelNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 200, 30)];
    modelNameLabel.text = u.modelName;
    modelNameLabel.font = [UIFont boldSystemFontOfSize:14];
//    modelNameLabel.textColor = [UIColor whiteColor];
    modelNameLabel.numberOfLines = 0;
    [modelNameLabel sizeToFit];
    [cell.contentView addSubview:modelNameLabel];
    
    // image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 79, 79)];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.sdgundam.cn/data-source/acc/unit-3g/%@.png", u.unitId]]];
    [cell.contentView addSubview:imageView];
    
    UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 49, 100, 21)];
    rankLabel.text = [NSString stringWithFormat:@"%@ Rank", u.rank];
    rankLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:14];
    rankLabel.textColor = [GDAppUtility UIColorFromRGB:0x475c8b];
    
    [cell.contentView addSubview:rankLabel];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // NSLog(@"%@",[NSThread callStackSymbols]);
    [self.searchBar resignFirstResponder];
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UnitInfoShort *u = [self.units objectAtIndex:indexPath.row];
    unitIdForSegue = u.unitId;
    [self performSegueWithIdentifier:@"ViewUnit" sender:self];
}


#pragma mark - Search Bar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Canceled");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search button clicked");
    
    [searchBar resignFirstResponder];
    [self searchUnitsWithKeyword:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchDelayer invalidate], searchDelayer = nil;
    if (searchText.length > 0) {
        searchDelayer = [NSTimer scheduledTimerWithTimeInterval:0.600 target:self selector:@selector(doDelayedSearch:) userInfo:searchText repeats:NO];
    } else {
        self.units = [NSArray arrayWithObjects:nil];
        [self.tableView reloadData];
    }
}

- (void)doDelayedSearch:(NSTimer *) t {
    assert(t == searchDelayer);

    [self searchUnitsWithKeyword:searchDelayer.userInfo];
    searchDelayer = nil;
}

@end
