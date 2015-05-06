//
//  POIViewController.m
//  POI Management
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "POIViewController.h"
#import "POITableViewCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <PWMapKit/PWMapKit.h>

@interface POIViewController ()

@property (strong) NSArray *buildingAnnotations;
@property (strong) NSMutableDictionary *annotationTypes;

@end

@implementation POIViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.annotationTypes = [NSMutableDictionary dictionary];
    [self.tableView registerClass:[POITableViewCell class] forCellReuseIdentifier:@"POITableViewCell"];
    
    
    __weak typeof(self) weakSelf = self;
    
    [[PWBuildingManager sharedManager] getBuildingAnnotationTypesWithCompletion:^(NSArray *types, NSError *error) {
        if (!error) {
            for (PWAnnotationType *type in types) {
                [weakSelf.annotationTypes setObject:type forKeyedSubscript:@(type.typeIdentifier)];
            }
        }
    }];
    
    [[PWBuildingManager sharedManager] getBuildingAnnotationsWithBuildingID:17457 completion:^(NSArray *annotations, NSError *error) {
        if (!error) {
            weakSelf.buildingAnnotations = annotations;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pointOfInterestVisibilityToggled:(UISwitch *)visibilitySwitch {
    CGPoint buttonPosition = [visibilitySwitch convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    PWBuildingAnnotation *buildingAnnotation = self.buildingAnnotations[indexPath.row];
    
    if (!visibilitySwitch.on) {
        [self.mapView hideBuildingAnnotationWithIdentifier:buildingAnnotation.annotationID];
    } else {
        [self.mapView stopHidingBuildingAnnotationWithIdentifier:buildingAnnotation.annotationID];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buildingAnnotations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POITableViewCell"];
    PWBuildingAnnotation *buildingAnnotation = [self.buildingAnnotations objectAtIndex:indexPath.row];
    PWAnnotationType *type = [self.annotationTypes objectForKey:@(buildingAnnotation.type)];
    
    cell.annotationTitleLabel.text = buildingAnnotation.title;
    [cell.visibilitySwitch removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [cell.visibilitySwitch addTarget:self action:@selector(pointOfInterestVisibilityToggled:) forControlEvents:UIControlEventValueChanged];
    
    if (type) {
        cell.annotationTypeLabel.text = type.typeDescription;
    }
    
    BOOL visibile = NO;
    for (PWBuildingAnnotation *mapBuildingAnnotation in self.mapView.annotations) {
        if (buildingAnnotation.annotationID == mapBuildingAnnotation.annotationID) {
            visibile = YES;
        }
    }
    
    cell.visibilitySwitch.on = visibile;
    [cell.annotationImageView setImageWithURL:buildingAnnotation.imageURL placeholderImage:nil];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
     


@end
