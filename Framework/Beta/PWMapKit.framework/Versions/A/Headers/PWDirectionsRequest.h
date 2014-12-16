//
//  PWDirectionsRequest.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWLocation/PWLocationProtocol.h>

#import "PWAnnotationProtocol.h"

/**
 `PWDirectionsType` specifies the type of directions to be used.
 */
typedef NS_ENUM(NSUInteger, PWDirectionsType) {
    PWDirectionsTypeUnknown = NSNotFound,
    PWDirectionsTypeAccessible = 0,
    PWDirectionsTypeAny
};


/**
 The `PWDirectionsRequest` class is used by apps that work with indoor directions. To request directions, create a new instance of this class and configure it with the start and end points you need. Then create a `PWDirections` object and use the methods of that class to initiate the request and process the results.
 */
@interface PWDirectionsRequest : NSObject

/**
 Returns the starting point for routing directions. This value will be `nil` if this request is initialized with `initWithLocation:destination:type:`. (read-only)
 */
@property (readonly) id<PWAnnotationProtocol> source;

/**
 Returns the end point for routing directions. (read-only)
 */
@property (readonly) id<PWAnnotationProtocol> destination;

/**
 The source location object. This value will be `nil` if this request is initialized with `initWithSource:destination:type:`. (read-only)
 */
@property (readonly) id<PWLocation> location;

/**
 The type of directions this request applies to.
 */
@property (readonly) PWDirectionsType type;

/**
 Initializes and returns a `PWDirectionsRequest` object with a source and destination annotation.
 @param source The source annotation. This object must conform to `PWAnnotationProtocol` and cannot be `nil`.
 @param destination The destination annotation. This object must conform to `PWAnnotationProtocol` protocol and cannot be `nil`.
 @param type The type of directions for this request.
 @return The initialized directions request object.
 */
- (instancetype)initWithSource:(id<PWAnnotationProtocol>)source destination:(id<PWAnnotationProtocol>)destination type:(PWDirectionsType)type;

/**
 Initializes and returns a `PWDirectionsRequest` object with a source location and a destination annotation.
 @param location The source location. This object must conform to the `PWLocation` protocol and cannot be `nil`.
 @param destination The destination annotation. This object must conform to `PWAnnotationProtocol` and cannot be `nil`.
 @param type The type of directions for this request.
 @return An initialized directions request object.
 */
- (instancetype)initWithLocation:(id<PWLocation>)location destination:(id<PWAnnotationProtocol>)destination type:(PWDirectionsType)type;

@end
