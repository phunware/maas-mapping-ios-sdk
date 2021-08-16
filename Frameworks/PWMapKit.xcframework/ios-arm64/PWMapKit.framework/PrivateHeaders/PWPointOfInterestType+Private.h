//
//  PWPointOfInterestType+Private.h
//  PWMapKit
//
//  Created by Illya Busigin on 10/23/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWPointOfInterestType.h"

@interface PWPointOfInterestType ()

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *iconURL;

- (instancetype)initWithIdentifier:(NSInteger)identifier name:(NSString *)name;

@end
