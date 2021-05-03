//
//  PWUserLocation+Private.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 01/08/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import "PWUserLocation.h"

@interface PWUserLocation()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger floorID;
@property (nonatomic, assign) NSInteger buildingID;
@property (nonatomic, assign) NSInteger campusID;
@property (nonatomic, assign) CLLocationAccuracy horizontalAccuracy;
@property (nonatomic, assign, getter=isAccessible) BOOL accessible;
@property (nonatomic, assign, getter=isVisualImpaired) BOOL visualImpaired;
@property (nonatomic, assign, getter=isExit) BOOL exit;
@property (nonatomic, strong) NSDate *timestamp;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           floorID:(NSUInteger)floorID
                        buildingID:(NSUInteger)buildingID
                          campusID:(NSUInteger)campusID
                horizontalAccuracy:(CLLocationAccuracy)hAccuracy
                         timestamp:(NSDate*)timestamp;

@end
