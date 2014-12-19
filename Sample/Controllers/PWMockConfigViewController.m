//
//  PWMockConfigViewController.m
//  PWMapKit
//
//  Created by Illya Busigin on 8/22/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMockConfigViewController.h"
#import <PWLocation/PWMockLocationManagerConfiguration.h>
#import <PWLocation/PWLocation.h>
#import "PWMockConfigTableViewCell.h"

typedef NS_ENUM(NSUInteger, PWMockConfigSection) {
    PWMockConfigSectionSettings = 0,
    PWMockConfigSectionDevelopment,
    PWMockConfigSectionStaging,
    PWMockConfigSectionProduction,
    PWMockConfigSectionCount
};

static NSString *kPWMockConfigSettingsCellIdentifier = @"kPWMockConfigSettingsCellIdentifier";
static NSString *kPWMockConfigCellIdentifier = @"kPWMockConfigCellIdentifier";

@interface PWMockConfigViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *developmentConfigurations;
@property (nonatomic, strong) NSMutableArray *stagingConfigurations;
@property (nonatomic, strong) NSMutableArray *productionConfigurations;

@end

@implementation PWMockConfigViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Selected Script"];
    
    self.navigationItem.title = @"Mock Configuration";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPWMockConfigSettingsCellIdentifier];
    [tableView registerClass:[PWMockConfigTableViewCell class] forCellReuseIdentifier:kPWMockConfigCellIdentifier];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = dismissButton;
    
    [self loadDataSource];
}

#pragma mark - Internal

- (void)loadDataSource
{
    self.developmentConfigurations = [NSMutableArray array];
    self.stagingConfigurations = [NSMutableArray array];
    self.productionConfigurations = [NSMutableArray array];

    NSDictionary *scripts = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MockLocationScripts" ofType:@"plist"]];
    
    // Populate development data
    NSArray *development = scripts[@"Development"];
    
    for (NSString *fileName in development) {
        NSString *fileURL = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:fileName.pathExtension];
        NSData *data = [NSData dataWithContentsOfFile:fileURL];
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        PWMockLocationManagerConfiguration *configuration = [PWMockLocationManagerConfiguration unpack:config];
        
        [self.developmentConfigurations addObject:configuration];
    }
    
    // Populate staging data
    NSArray *staging = scripts[@"Staging"];
    
    for (NSString *fileName in staging) {
        NSString *fileURL = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:fileName.pathExtension];
        NSData *data = [NSData dataWithContentsOfFile:fileURL];
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        PWMockLocationManagerConfiguration *configuration = [PWMockLocationManagerConfiguration unpack:config];
        
        [self.stagingConfigurations addObject:configuration];
    }
    
    
    // Populate production data
    NSArray *production = scripts[@"Production"];
    
    for (NSString *fileName in production) {
        NSString *fileURL = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:fileName.pathExtension];
        NSData *data = [NSData dataWithContentsOfFile:fileURL];
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        PWMockLocationManagerConfiguration *configuration = [PWMockLocationManagerConfiguration unpack:config];
        
        [self.productionConfigurations addObject:configuration];
    }
    
    [self.tableView reloadData];
}

- (PWMockLocationManagerConfiguration *)configurationForIndexPath:(NSIndexPath *)indexPath
{
    PWMockLocationManagerConfiguration *configurationForIndexPath = nil;
    
    switch (indexPath.section) {
        case PWMockConfigSectionDevelopment:
            configurationForIndexPath = self.developmentConfigurations[indexPath.row];
            break;
            
        case PWMockConfigSectionStaging:
            configurationForIndexPath = self.stagingConfigurations[indexPath.row];
            break;
            
        case PWMockConfigSectionProduction:
            configurationForIndexPath = self.productionConfigurations[indexPath.row];
            break;
            
        default:
            break;
    }
    
    return configurationForIndexPath;
}

#pragma mark - Actions

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewCells

- (UITableViewCell *)mockConfigurationSettingsCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPWMockConfigSettingsCellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Repeat";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UISwitch *repeatScriptSwitch = [UISwitch new];
    cell.accessoryView = repeatScriptSwitch;
    
    return cell;
}

- (UITableViewCell *)mockConfigurationScriptCellForIndexPath:(NSIndexPath *)indexPath
{
    PWMockConfigTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPWMockConfigCellIdentifier forIndexPath:indexPath];
    
    PWMockLocationManagerConfiguration *configuration = [self configurationForIndexPath:indexPath];
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = configuration.name;
    cell.detailTextLabel.text = configuration.configurationDescription;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *currentConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"Selected Script"];
    
    if ([configuration.name isEqualToString:currentConfig]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    
    switch (section) {
        case PWMockConfigSectionSettings:
            numberOfRowsInSection = 1;
            break;
            
        case PWMockConfigSectionDevelopment:
            numberOfRowsInSection = self.developmentConfigurations.count;
            break;
            
        case PWMockConfigSectionStaging:
            numberOfRowsInSection = self.stagingConfigurations.count;
            break;
            
        case PWMockConfigSectionProduction:
            numberOfRowsInSection = self.productionConfigurations.count;
            break;
            
        default:
            break;
    }
    
    return numberOfRowsInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PWMockConfigSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == PWMockConfigSectionSettings) {
        cell = [self mockConfigurationSettingsCellForIndexPath:indexPath];
    } else {
        cell = [self mockConfigurationScriptCellForIndexPath:indexPath];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleForHeaderInSection = nil;
    
    switch (section) {
        case PWMockConfigSectionDevelopment:
            titleForHeaderInSection = @"Development";
            break;
            
        case PWMockConfigSectionStaging:
            titleForHeaderInSection = @"Staging";
            break;
            
        case PWMockConfigSectionProduction:
            titleForHeaderInSection = @"Production";
            break;
            
        default:
            break;
    }
    
    return titleForHeaderInSection;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRowAtIndexPath = 88;
    
    switch (indexPath.section) {
        case PWMockConfigSectionSettings:
            heightForRowAtIndexPath = 44;
            break;
            
        default:
            break;
    }
    
    return heightForRowAtIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != PWMockConfigSectionSettings) {
        PWMockLocationManagerConfiguration *selectedConfiguration = [self configurationForIndexPath:indexPath];
        
        // Save current to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:selectedConfiguration.name forKey:@"Selected Script"];
        [self.tableView reloadData];
        
        // Notify PWViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kPWMockLocationManagerConfigurationChanged" object:selectedConfiguration userInfo:nil];
    }
}

@end
