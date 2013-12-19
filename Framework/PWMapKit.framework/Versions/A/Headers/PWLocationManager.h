//
//  PWLocationManager.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PWLocationManagerDelegate;

@interface PWLocationManager : NSObject

@property (nonatomic, weak) id<PWLocationManagerDelegate> delegate;

+ (instancetype)defaultManager;
+ (BOOL)locationServicesEnabled;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end


@protocol PWLocationManagerDelegate <NSObject>

- (void)locationManager:(PWLocationManager *)manager didUpdateToLocation:(CGPoint)location floorID:(NSUInteger)floorID;

- (void)locationManager:(PWLocationManager *)manager didFailWithError:(NSError *)error;

@end 