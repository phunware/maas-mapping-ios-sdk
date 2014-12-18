//
//  PWBuildingFloorResource.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMappingTypes.h"

@interface PWBuildingFloorResource : NSObject

@property (readonly) PWBuildingFloorResourceIdentifier resourceID;
@property (readonly) PWBuildingFloorIdentifier floorID;

@property (readonly) NSString *PDFURL;
@property (readonly) NSString *SVGURL;

@property (readonly) CGFloat zoomLevel;

@property (readonly) NSDate *creationDate;
@property (readonly) NSDate *lastUpdated;
@property (readonly) NSString *resourceKey;

@end
