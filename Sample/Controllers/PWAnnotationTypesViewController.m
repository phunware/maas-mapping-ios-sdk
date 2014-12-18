//
//  PWPOITypesViewController.m
//  PWMapKit
//
//  Created by Illya Busigin on 10/17/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWAnnotationTypesViewController.h"
#import "PWAnnotationTypeCell.h"

#import <PWMapKit/PWMapKit.h>

@interface PWAnnotationTypesViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PWAnnotationTypesViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Annotation Types";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    __weak __typeof(&*self)weakSelf = self;
    [[PWBuildingManager sharedManager] getBuildingAnnotationTypesWithCompletion:^(NSArray *types, NSError *error) {
        weakSelf.dataSource = types;
        [weakSelf.tableView reloadData];
    }];
    
    [self.tableView registerClass:[PWAnnotationTypeCell class] forCellReuseIdentifier:@"identifier"];
}

#pragma mark - Actions

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    PWAnnotationType *annotationType = self.dataSource[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%li", (long)annotationType.typeIdentifier];
    cell.detailTextLabel.text = annotationType.typeDescription;
    
    return cell;
}

@end
