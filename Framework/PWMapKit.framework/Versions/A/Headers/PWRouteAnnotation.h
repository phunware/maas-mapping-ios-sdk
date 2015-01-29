//
//  PWRouteAnnotation.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWAnnotationProtocol.h"

/**
 This object is returned in the `annotations` property in a `PWRoute` object. You should never instantiate this annotation directly.
 */
@interface PWRouteAnnotation : NSObject <PWAnnotationProtocol>

/**
 Indicates whether or not this point on the route is considered a building entry/exit. (read-only)
 */
@property (readonly, getter=isExit) BOOL exit;

/**
 Indicates whether or not this point on the route represents an accessible location. (read-only)
 */
@property (readonly, getter=isAccessible) BOOL accessible;

/**
 For multi-level building elements like elevators and stairs, this value provides a common identifier for associating the route annotations on each floor. (read-only)
 */
@property (copy, readonly) NSString *portalID;

/**
 The building annotation type. (read-only)
 */
@property (readonly) PWBuildingAnnotationType type;

@end
