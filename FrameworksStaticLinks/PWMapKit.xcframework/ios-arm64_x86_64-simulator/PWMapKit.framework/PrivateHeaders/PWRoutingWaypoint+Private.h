//
//  PWRoutingWaypoint+Private.h
//  PWMapKit
//
//  Created by Sam Odom on 3/20/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import "PWRoutingWaypoint.h"
#import "PWMappingTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWRoutingWaypoint ()

@property (nonatomic) BOOL accessible;
@property (nonatomic) BOOL visualImpaired;
@property (nonatomic) BOOL exit;
@property (nonatomic) BOOL active;
@property (nonatomic, nullable) NSString *title;
@property (nonatomic, weak, nullable) PWFloor *floor;
@property (nonatomic, nullable) NSDictionary *metaData;
@property (nonatomic) NSInteger campusID;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           floorID:(NSInteger)floorID
                        buildingID:(PWBuildingIdentifier)buildingID
                      annotationID:(PWAnnotationIdentifier)annotationID;

@end

NS_ASSUME_NONNULL_END
