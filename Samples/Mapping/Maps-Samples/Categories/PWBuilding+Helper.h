//
//  PWMapView+Helper.h
//  Maps-Samples
//
//  Created on 9/16/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWMapKit/PWMapKit.h>

@interface PWBuilding(Helper)

- (NSArray *)getAllPOIs;

- (NSArray *)getAvailablePOITypes;

- (PWFloor *)floorForFloorID:(NSInteger)floorID;

@end
