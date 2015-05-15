//
//  PWManeuverListViewTableViewController.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWManeuverListViewController+Private.h"
#import "PWManeuverListTableViewCell.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString * const PWManeuverListViewTableViewCellIdentifier =  @"PWManeuverListViewTableViewCellIdentifier";

@interface PWManeuverListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation PWManeuverListViewController

#pragma mark - Controler lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 50.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PWManeuverListTableViewCell" bundle:nil] forCellReuseIdentifier:PWManeuverListViewTableViewCellIdentifier];
    self.navigationBar.clipsToBounds = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
    
    [self refreshView];
}

#pragma mark - Overriding properties

-(void)setMapView:(PWMapView *)mapView {
    _mapView = mapView;
    
    [self refreshView];
}

#pragma mark - Private methods

-(IBAction)doneButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshView {
    self.maneuvers = [self maneuversFromMap];
    [self.tableView reloadData];
}

- (NSArray*)maneuversFromMap {
   return  self.mapView.currentRoute.maneuvers;
}

- (PWRouteManeuver*)currentManeuver {
    return self.mapView.currentManeuver;
}

- (BOOL)isManeuverCompleted:(PWRouteManeuver*)maneuver {
    if (maneuver.index<[self currentManeuver].index) {
        return YES;
    }else{
        return NO;
    }
}

- (void)configureTableViewCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    PWManeuverListTableViewCell *directionsCell = (PWManeuverListTableViewCell*)cell;
    directionsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    PWRouteManeuver *maneuver = self.maneuvers[indexPath.row];
    [directionsCell configureWithManeuver:maneuver withCompletedState:[self isManeuverCompleted:maneuver] inMapView:self.mapView];
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.maneuvers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PWManeuverListViewTableViewCellIdentifier forIndexPath:indexPath];
    [self configureTableViewCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return UITableViewAutomaticDimension;
    }
    
    static PWManeuverListTableViewCell *dummyCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dummyCell = [self.tableView dequeueReusableCellWithIdentifier:PWManeuverListViewTableViewCellIdentifier];
        if (!dummyCell) {
            dummyCell = [[PWManeuverListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PWManeuverListViewTableViewCellIdentifier];
        }
    });
    
    [self configureTableViewCell:dummyCell atIndexPath:indexPath];
    
    dummyCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds),CGRectGetHeight(dummyCell.bounds));
    
    [dummyCell setNeedsLayout];
    [dummyCell layoutIfNeeded];
    
    CGFloat height = [dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1.0;
}

@end
