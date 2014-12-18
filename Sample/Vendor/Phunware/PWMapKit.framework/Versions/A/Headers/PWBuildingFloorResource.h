//
//  PWFloorResource.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWBuildingFloorResource : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger resourceID;
@property (nonatomic, assign) NSUInteger floorID;

@property (nonatomic, strong) NSString *PDFURL;
@property (nonatomic, strong) NSString *SVGURL;

@property (nonatomic, assign) CGFloat zoomLevel;

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *lastUpdated;

+ (instancetype)unpack:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

- (NSString *)resourceKey;

@end
