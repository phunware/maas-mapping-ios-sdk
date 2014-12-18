//
//  PWRouteSegment.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWRouteSegment : NSObject

@property (nonatomic, assign) NSInteger annotationID;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger floorID;

@property (nonatomic, assign) BOOL isExit;
@property (nonatomic, assign) BOOL isAccessible;
@property (nonatomic, strong) NSString *portalID;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *directionAnnotation;

@property (nonatomic, readonly) BOOL isTransitPoint;

@end
