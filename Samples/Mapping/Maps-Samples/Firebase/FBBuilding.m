//
//  PWBuilding.m
//  PWLocation
//
//  Created by Chesley Stephens on 2/23/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <PWLocation/PWLocation.h>

#import "FBBuilding.h"

@interface FBBuilding ()

@property (nonatomic, strong) NSArray *senionFloors;
@property (nonatomic, strong) NSArray *senionMaasFloors;

@end

@implementation FBBuilding

- (instancetype)initWithSnapshotValue:(NSDictionary *)snapshotValue {
    if (self = [super init]) {
        NSDictionary *iosKeys = snapshotValue[@"ios"];
        
        _accessKey = iosKeys[@"accessKey"];
        _appId = iosKeys[@"appId"];
        _bpOrgId = snapshotValue[@"bpOrgId"];
        _buildingId = snapshotValue[@"buildingId"];
        _cmxGuid = snapshotValue[@"cmxGuid"];
        _cmxFloors = [self dictionaryFromArray:snapshotValue[@"cmxFloors"]];
        _environment = [self environmentForType:snapshotValue[@"environment"]];
        _name = snapshotValue[@"name"];
        _mistOrgId = snapshotValue[@"mistOrgId"];
        _senionFloors = snapshotValue[@"senionFloors"];
        _senionMaasFloors = snapshotValue[@"senionMaasFloors"];
        _senionMaasFloorMap = [self senionMaasMapping];
        _senionId = snapshotValue[@"senionId"];
        _senionMapKey = snapshotValue[@"senionMapKey"];
        _signatureKey = iosKeys[@"signatureKey"];
        _providerType = FBProviderTypeManaged;
        
        [self configureSupportedTypes];
    }
    
    return self;
}

- (void)configureSupportedTypes {
    NSMutableArray *supportedTypes = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:FBProviderTypeManaged], nil];
    
    if (self.cmxGuid.length > 0) {
        [supportedTypes addObject:[NSNumber numberWithInteger:FBProviderTypeCMX]];
    }
    if (self.senionId.length > 0) {
        [supportedTypes addObject:[NSNumber numberWithInteger:FBProviderTypeSenion]];
    }
    
    self.supportedTypes = [supportedTypes copy];
}

- (NSDictionary *)senionMaasMapping {
    if (self.senionFloors.count == 0 || self.senionFloors.count != self.senionMaasFloors.count) {
        return nil;
    }
    
    NSMutableDictionary *senionMaasMapping = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.senionFloors.count; i++) {
        NSString *senionFloorKey = self.senionFloors[i];
        NSString *senionMaasString = self.senionMaasFloors[i];
        senionMaasMapping[senionFloorKey] = senionMaasString;
    }
    
    return [senionMaasMapping copy];
}

- (NSDictionary *)dictionaryFromArray:(NSArray *)array {
    if (array.count == 0 || (array.count > 0 && [array[0] length] == 0)) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%i", i];
        dict[key] = array[i];
    }
    
    return [dict copy];
}

- (PWEnvironment)environmentForType:(NSString *)environmentType {
    PWEnvironment environment = PWEnvironmentDev;
    
    if ([environmentType rangeOfString:@"dev" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        environment = PWEnvironmentDev;
    } else if ([environmentType rangeOfString:@"stage" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        environment = PWEnvironmentStage;
    } else if ([environmentType rangeOfString:@"prod" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        environment = PWEnvironmentProd;
    }
    
    return environment;
}

+ (NSString *)stringForProviderType:(FBProviderType)providerType {
    NSString *stringType = @"Managed";
    
    switch (providerType) {
        case FBProviderTypeCMX:
            stringType = @"CMX";
            break;
        case FBProviderTypeSenion:
            stringType = @"Senion";
            break;
        case FBProviderTypeManaged:
            stringType = @"Managed";
            break;
    }
    
    return stringType;
}

- (void)configureManagedLocationManager {
    self.managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:[self.buildingId integerValue]];
}

@end
