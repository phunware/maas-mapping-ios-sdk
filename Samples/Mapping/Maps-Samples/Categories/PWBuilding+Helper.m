//
//  PWMapView+Helper.m
//  Maps-Samples
//
//  Created on 9/16/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PWBuilding+Helper.h"

@implementation PWBuilding(Helper)

- (NSArray *)getAllPOIs {
    NSMutableArray *allPOIs = [NSMutableArray new];
    for (PWFloor *floor in self.floors) {
        [allPOIs addObjectsFromArray:floor.pointsOfInterest];
    }
    return allPOIs.copy;
}

- (NSArray *)getAvailablePOITypes {
    NSMutableArray *availablePOITypes = [NSMutableArray new];
    
    for (PWPointOfInterest *poi in [self getAllPOIs]) {
        if (![availablePOITypes containsObject:poi.pointOfInterestType]) {
            [availablePOITypes addObject:poi.pointOfInterestType];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [availablePOITypes sortUsingDescriptors:@[sortDescriptor]];
    
    return [availablePOITypes copy];
}

- (PWFloor *)floorForFloorID:(NSInteger)floorID {
    return [[self.floors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floorID == %@", @(floorID)]] firstObject];
}

@end
