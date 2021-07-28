//
//  PWBuildingFloorResource+Private.h
//  PWMapKit
//
//  Created by Sam Odom on 10/20/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWBuildingFloorResource.h"

@interface PWBuildingFloorResource ()

@property PWBuildingFloorResourceIdentifier resourceID;
@property NSInteger floorID;

@property NSString *PDFURL;
@property NSString *SVGURL;

@property CGFloat zoomLevel;

@property NSDate *creationDate;
@property NSDate *lastUpdated;
@property NSString *resourceKey;

@end
