//
//  PWLocationManager.h
//  PWMapKit
//
//  Created by Illya Busigin on 2/7/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWLocationProtocol.h>

@protocol PWLocationManagerDelegate;

@protocol PWLocationManager <NSObject>

+ (BOOL)locationServicesEnabled;
    
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
- (BOOL)updating;

@property (nonatomic, weak) id<PWLocationManagerDelegate> delegate;
    
@end

@protocol PWLocationManagerDelegate <NSObject>

@optional
- (void)locationManager:(id<PWLocationManager>)manager didUpdateToLocation:(id<PWLocation>)location;
- (void)locationManager:(id<PWLocationManager>)manager failedWithError:(NSError *)error;
    
@end

