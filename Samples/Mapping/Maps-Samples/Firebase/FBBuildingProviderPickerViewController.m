//
//  PWBuildingTypePickerViewController.m
//  PWLocation
//
//  Created by Chesley Stephens on 2/27/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import "FBBuildingProviderPickerViewController.h"

#import "FBBuilding.h"

NSString *const FBBuildingTypeCellIdentifier = @"FBBuildingTypeCellIdentifier";

@interface FBBuildingProviderPickerViewController()

@end

@implementation FBBuildingProviderPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Providers";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FBBuildingTypeCellIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numberOfRowsInSection = [[self.selectedBuilding supportedTypes] count];
    
    return numberOfRowsInSection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FBBuildingTypeCellIdentifier forIndexPath:indexPath];
    
    FBProviderType type = [[[self.selectedBuilding supportedTypes] objectAtIndex:indexPath.row] integerValue];
    
    cell.textLabel.text = [FBBuilding stringForProviderType:type];
    
    if (type == self.selectedBuilding.providerType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedBuilding.providerType = [[[self.selectedBuilding supportedTypes] objectAtIndex:indexPath.row] integerValue];
    
    if ([self.delegate respondsToSelector:@selector(didSelectProvider)]) {
        [self.delegate didSelectProvider];
    }
    
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
