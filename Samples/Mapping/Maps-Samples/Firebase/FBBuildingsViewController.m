//
//  ProvidersViewController.m
//  PWLocation
//
//  Created by Illya Busigin on 1/6/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWCore/PWCore.h>

#import "PWCore+Private.h"

#import "FBBuildingsViewController.h"
#import "FBBuilding.h"
#import "FBBuildingProviderPickerViewController.h"

NSString *const FBBuildingCellIdentifier = @"FBBuildingCellIdentifier";

@interface FBBuildingsViewController() <FBBuildingProviderPickerDelegate>

@property (nonatomic, strong) FBBuildingManager *buildingManager;

@end

@implementation FBBuildingsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Buildings";

    self.buildingManager = [FBBuildingManager shared];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildingManagerUpdated) name:FBBuildingManagerUpdateNotification object:nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FBBuildingCellIdentifier];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSNotificationCenter

- (void)buildingManagerUpdated {
    [self.tableView reloadData];
}

#pragma mark - PWBuildingProviderPickerDelegate

- (void)didSelectProvider {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numberOfRowsInSection = [[self.buildingManager buildings] count];

    return numberOfRowsInSection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FBBuildingCellIdentifier forIndexPath:indexPath];

    FBBuilding *building = [[self.buildingManager buildings] objectAtIndex:[indexPath row]];
    cell.textLabel.text = building.name;
    
    if (self.buildingManager.currentBuilding == building) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.detailTextLabel.text = [FBBuilding stringForProviderType:building.providerType];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = nil;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FBBuilding *buildingTouched = [[self.buildingManager buildings] objectAtIndex:[indexPath row]];
    if (self.buildingManager.currentBuilding != buildingTouched) {
        self.buildingManager.currentBuilding = buildingTouched;
        if (self.completion != nil) {
            self.completion();
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)pushBuildingProviderPicker {
    FBBuildingProviderPickerViewController *buildingProviderPickerVC = [[FBBuildingProviderPickerViewController alloc] init];
    buildingProviderPickerVC.selectedBuilding = self.buildingManager.currentBuilding;
    buildingProviderPickerVC.delegate = self;
    
    [self.navigationController pushViewController:buildingProviderPickerVC animated:YES];
}

@end
