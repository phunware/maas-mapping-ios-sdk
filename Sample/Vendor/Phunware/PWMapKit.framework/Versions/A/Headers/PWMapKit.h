//
//  PWMapKit.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWMapKit/PWMapView.h>
#import <PWMapKit/PWMapAnnotation.h>
#import <PWMapKit/PWAnnotationView.h>
#import <PWMapKit/PWMapLocation.h>

/**
 The `PWMapKit` framework provides an interface for embedding indoor maps directly into your own windows and views. This framework also provides support for annotating the map, finding your location, fetching and drawing routes, and more.
 */

@interface PWMapKit : NSObject

///-------------------------
/// @name Annotation Methods
///-------------------------

/**
 Fetch annotations for the specified building ID.
 @param buildingID The building ID you want to fetch map annotations for.
 @param completion A block object to be executed when `getMapAnnotationsForBuildingID:completion:` completes. This block has no return value and takes two arguments:,
 - A `PWRoute` object that encapsulates the requested route. Pass this object to the `PWMapView` to draw it on the map.
 - An `NSError` object describing the error that occurred. If there was no error this object will be `nil`.
 */
+ (void)getMapAnnotationsForBuildingID:(NSString *)buildingID completion:(void (^)(NSArray *mapAnnotations, NSError *error))completion;

///----------------------
/// @name Routing Methods
///----------------------

/**
 Get a route between two annotation IDs. If no route exists, an `NSError` object with be returned on completion.
 @param fromAnnotationID The origin annotation ID that you wish to route from.
 @param toAnnotationID The destination annotation ID that you wish to route to.
 @param completion A block object to be executed when `getRouteFromAnnotationID:toAnnotationID:completion:` completes. This block has no return value and takes two arguments:,
 - A `PWRoute` object that encapsulates the requested route. Pass this object to the `PWMapView` to draw it on the map.
 - An `NSError` object describing the error that occurred. If there was no error this object will be `nil`.
 */
+ (void)getRouteFromAnnotationID:(NSInteger)fromAnnotationID toAnnotationID:(NSInteger)toAnnotationID completion:(void (^)(PWRoute *route, NSError *error))completion;

/**
 Route from a specified map location to a desired point of interest.
 @param mapLocation The map location you wish to route from. This can be instantiated by the developer or you can fetch the current `PWMapLocation` of the user from the `PWMapView`.
 @param toAnnotationID The destination annotation ID that you wish to route to.
 @param completion A block object to be executed when `getRouteFromMapLocation:toAnnotationID:completion:` completes. This block has no return value and takes two arguments:,
 - A `PWRoute` object that encapsulates the requested route. Pass this object to the `PWMapView` to draw it on the map.
 - An `NSError` object describing the error that occurred. If there was no error this object will be `nil`.
 */
+ (void)getRouteFromMapLocation:(PWMapLocation *)mapLocation toAnnotationID:(NSInteger)toAnnotationID completion:(void (^)(PWRoute *route, NSError *error))completion;

///----------------------
/// @name Utility Methods
///----------------------

/**
 Returns 'PWMapKit'.
 */
+ (NSString *)serviceName;

/**
 Clears all mapping data caches. This method blocks the calling thread until the cache has been cleared.
 */
+ (void)clearCache;

@end
