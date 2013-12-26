//
//  PWMapView.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PWMapKit/PWAnnotationView.h>
#import <PWMapKit/PWMapLocation.h>

@class PWBuildingFloor, PWRoute;

@protocol PWMapViewDelegate;

/**
 A `PWMapView` object provides an embeddable indoor map interface. You use this class as-is to display indoor map information and to manipulate the map contents from your application. You can center the map on a given coordinate, specify the size of the area you want to display, annotate the map with custom points of interest, route between points, and more.
 */

@interface PWMapView : UIView

///----------------------
/// @name Utility Methods
///----------------------

/**
 Returns the building ID that initialized the `PWMapView` object.
 */
@property (nonatomic, strong) NSString *buildingID;

/**
 Returns the map name that has beend specified for the map in MaaS Portal -> Location.
 */
@property (nonatomic, strong) NSString *mapName;

/**
 Returns an `NSArray` of objects that conform to the `PWAnnotation` protocol. This array may be nil or empty while the map is loading. You should only try and access this property after recieving the `mapViewDidLoad:` delegate callback.
 */
@property (nonatomic, readonly) NSArray *annotations;

/**
 Returns an `NSArray` of `PWFloor` objects. This array may be nil or empty while the map is loading. You should only try and access this property after recieving the `mapViewDidLoad:` delegate callback.
 */
@property (nonatomic, readonly) NSArray *floors;

/**
 Returns the currently displayed floor. This array may be nil or empty while the map is loading. You should only try and access this property after recieving the `mapViewDidLoad:` delegate callback.
 */
@property (nonatomic, assign) PWBuildingFloor *currentFloor;

/**
 A floating-point value that specifies the current scale factor applied to the map view's content.
 */
@property (nonatomic, assign) CGFloat zoomScale;

/**
 A `BOOL` value that determines whether the user may scroll around the map.
 */
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

/**
 The receiver’s delegate.
 @discussion A map view sends messages to its delegate regarding the loading of map data and changes in the portion of the map being displayed. The delegate also manages the annotation views used to highlight points of interest on the map.
 
 The delegate should implement the methods of the `PWMapViewDelegate` protocol.
 */
@property (nonatomic, weak) id<PWMapViewDelegate> delegate;


///-----------------------------
/// @name Initialization & Setup
///-----------------------------

/**
 Initialize a map view with the specified frame, building ID, and venue ID.
 @param frame A rectangle specifying the initial location and size of the map view in its superview's coordinates.
 @param buildingID The building ID for the map view. This value can be found in the Location area of MaaS Portal
 @param venueID The venue ID for the map view. This value can be found in the Location area of MaaS Portal.
 */
- (instancetype)initWithFrame:(CGRect)frame buildingID:(NSString *)buildingID venueID:(NSString *)venueID;


///----------------------
/// @name Changing Floors
///----------------------

/**
 Change the currently displayed floor to another `PWBuildingFloor` object. Passing the same floor will have no effect. When the floor change is complete the completion block is called.
 @param newCurrentFloor The `PWBuildingFloor` object that you would like to set as the current floor.
 @param completion A block object to be executed when `setCurrentFloor:completion:` completes. This block has no return value and takes one argument:,
 - A `BOOL` value that indicates whether or not the floor change succeeded.
 */
- (void)setCurrentFloor:(PWBuildingFloor *)newCurrentFloor completion:(void (^)(BOOL didSucceed))completion;


///------------------
/// @name Annotations
///------------------

/**
 Reloads the visible annotations.
 */
- (void)refreshAnnotations;

/**
 Adds the specified annotation to the map view.
 @param annotation The annotation object to add to the receiver. This object must conform to the `PWAnnotation` protocol. The map view retains the specified object.
 */
- (void)addAnnotation:(id<PWAnnotation>)annotation;

/**
 Adds an array of annotations to the map view.
 @param annotations An array of annotation objects. Each object in the array must conform to the `PWAnnotation` protocol. The map view retains the individual annotation objects.
 */
- (void)addAnnotations:(NSArray *)annotations;

/**
 Removes the specified annotation object from the map view.
 @param annotation The annotation object to remove. This object must conform to the `PWAnnotation` protocol.
 @discussion If the annotation is currently associated with an annotation view, and that view has a reuse identifier, this method removes the annotation view and queues it internally for later reuse. You can retrieve queued annotation views (and associate them with new annotations) using the `dequeueReusableAnnotationViewWithReuseIdentifier:` method.
 
 Removing an annotation object disassociates it from the map view entirely, preventing it from being displayed on the map. Thus, you would typically call this method only when you want to hide or delete a given annotation.
 */
- (void)removeAnnotation:(id<PWAnnotation>)annotation;

/**
 Removes an array of annotation objects from the map view.
 @param annotations The annotation object to remove. This object must conform to the PWAnnotation protocol.
 @discussion If any annotation object in the array has an associated annotation view, and if that view has a reuse identifier, this method removes the annotation view and queues it internally for later reuse. You can retrieve queued annotation views (and associate them with new annotations) using the `dequeueReusableAnnotationViewWithReuseIdentifier:` method.
 
 Removing annotation objects disassociates them from the map view entirely, preventing them from being displayed on the map. Thus, you would typically call this method only when you want to hide or delete the specified annotations.
 */
- (void)removeAnnotations:(NSArray *)annotations;

/**
 Removes all annotation objects from the map view.
 @discussion If any annotation objects have an associated annotation view, and if that view has a reuse identifier, this method removes the annotation view and queues it internally for later reuse. You can retrieve queued annotation views (and associate them with new annotations) using the `dequeueReusableAnnotationViewWithReuseIdentifier:` method.
 
 Removing annotations disassociates them from the map view entirely, preventing them from being displayed on the map. Thus, you would typically call this method only when you want to hide or delete the specified annotations.
 */
- (void)removeAllAnnotations;

/**
 Returns a reusable annotation view located by its identifier.
 @param reuseIdentifier A string identifying the annotation view to be reused. This string is the same one you specify when initializing the annotation view using the `initWithAnnotation:reuseIdentifier:` method.
 @discussion For performance reasons, you should generally reuse `PWAnnotationView` objects in your map views. As annotation views move offscreen, the map view moves them to an internally managed reuse queue. As new annotations move onscreen, and your code is prompted to provide a corresponding annotation view, you should always attempt to dequeue an existing view before creating a new one. Dequeueing saves time and memory during performance-critical operations such as scrolling.
 */
- (PWAnnotationView *)dequeueReusableAnnotationViewWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 Returns the annotation view associated with the specified annotation object, if any.
 @param annotation The annotation object whose view you want.
 @discussion The annotation view or nil if the view has not yet been created. This method may also return nil if the annotation is not in the visible map region and therefore does not have an associated annotation view.
 */
- (PWAnnotationView *)viewForAnnotation:(id<PWAnnotation>)annotation;


///------------------
/// @name Positioning
///------------------

/**
 Centers the map view on the navigation annotation (the blue dot). If no navigation annotation exists, this method does nothin.
 */
- (void)centerNavigationAnnotation;

/**
 Changes the center coordinate of the map and optionally animates the change.
 @param center The new center coordinate for the map.
 @param animated Specify `YES` if you want the map view to scroll to the new location or `NO` if you want the map to display the new location immediately.
 @discussion Changing the center coordinate centers the map on the new coordinate without changing the current zoom level. Because indoor maps are not infinite in nature some locations may not be able to be positioned in the center. In these instances the best effort will be applied.
 */
- (void)setCenterCoordinate:(CGPoint)center animated:(BOOL)animated;

/**
 Changes the center coordinate of the map  at the specified zoom scale and optionally animates the change.
 @param center The new center coordinate for the map.
 @param zoomLevel The desired zoom level.
 @param animated Specify `YES` if you want the map view to scroll and zoom to the new location or `NO` if you want the map to display the new location and zoom level immediately.
 @discussion Changing the center coordinate centers the map on the new coordinate while also changing to the specified zoom level. Because indoor maps are not infinite in nature some locations may not be able to be positioned in the center. In these instances the best effort will be applied.
 */
- (void)setCenterCoordinate:(CGPoint)center zoomLevel:(NSInteger)zoomLevel animated:(BOOL)animated;

/**
 A floating-point value that specifies the current zoom scale.
 @param zoomScale The new value to scale the content to.
 @param animated `YES` to animate the transition to the new scale, `NO` to make the transition immediate.
 @discussion The new scale value should be between the minimumZoomScale and the maximumZoomScale.
 */
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;


///---------------
/// @name Location
///---------------

/**
 Use this method to turn location tracking on or off.
 @param completion A block object to be executed when `toggleLocationTrackingWithCompletion:completion:` completes. This block has no return value and takes two arguments:,
 - A `BOOL` value that indicates whether or not the location tracking change succeeded.
 - An `NSError` object describing the error that occurred. If there was no error this object will be `nil`.
 */
- (void)toggleLocationTrackingWithCompletion:(void (^)(BOOL didSucceed, NSError *error))completion;

/**
 Informs the current location tracking status. If location tracking is enabled the return value would be `YES`.
 */
- (BOOL)trackingEnabled;

/**
 Returns the device location as a `PWMapLocation` object. The PWMapLocation object contains the x,y in the building coordinate space as well as a floor ID.
 */
- (PWMapLocation *)currentLocation;


///-----------------
/// @name Navigation
///-----------------

/**
 Load a route to be displayed on the map view.
 @param route The `PWRoute` object you wish to display on the map view.
 */
- (void)loadRoute:(PWRoute *)route;

/**
 Cancel the route being displayed on the map view. This method will remove the route from the map view.
 */
- (void)cancelRouting;

/**
 Returns a `BOOL` value that indicates whether or not the route has additional segment(s).
 @discussion You can use this method to enable/disable route traversal buttons.
 */
- (BOOL)hasNextRouteSegment;

/**
 Show the next route segment on the map view. If a route does not have any additional segments this method will do nothing.
 */
- (void)showNextRouteSegment;

/**
 Returns a BOOL value that indicates whether or not the route has previous segment(s).
 @discussion You can use this method to enable/disable route traversal buttons.
 */
- (BOOL)hasPreviousRouteSegment;

/**
 Show the previous route segment on the map view. If a route does not have any previous segments this method will do nothing.
 */
- (void)showPreviousRouteSegment;

@end

/**
 The `PWMapViewDelegate` protocol defines a set of optional methods that you can use to receive map-related update messages. Because many map operations require the `PWMapView` class to load data asynchronously, the map view calls these methods to notify your application when specific operations complete. The map view also uses these methods to request annotations and to manage interactions with those views.
 */
@protocol PWMapViewDelegate <NSObject>

@required

///-------------------------
/// @name Map View Lifecycle
///-------------------------

/**
 Tells the delegate that the specified map view successfully loaded the needed map data.
 @param mapView The map view that started the load operation.
 */
- (void)mapViewDidLoad:(PWMapView *)mapView;

/**
 Tells the delegate that the specified view was unable to load the map data.
 @param mapView The map view that started the load operation.
 @param error The reason that the map data could not be loaded
 @discussion This method might be called in situations where the device does not have access to the network or is unable to load the map data for some reason. You can use this message to notify the user that the map data is unavailable.
 */
- (void)mapView:(PWMapView *)mapView failedToLoadWithError:(NSError *)error;

@optional

///------------------
/// @name Annotations
///------------------

/**
 Tells the delegate that one of its annotation views was selected.
 @param mapView The map view containing the annotation view.
 @param view The annotation view that was selected.
 */
- (void)mapView:(PWMapView *)mapView didSelectAnnotationView:(PWAnnotationView *)view;

/**
 Returns the view associated with the specified annotation object.
 @param mapView The map view that requested the annotation view.
 @param annotation The object representing the annotation that is about to be displayed.
 @return The annotation view to display for the specified annotation or nil if you want to display a standard annotation view.
 */
- (PWAnnotationView *)mapView:(PWMapView *)mapView viewForAnnotation:(id<PWAnnotation>)annotation;


///---------------
/// @name Location
///---------------

/**
 Tells the delegate that a new location value is available.
 @param mapView The map view that had the location update.
 @param location The new location data.
 @param floorID The floor ID for the new location.
 */
- (void)mapView:(PWMapView *)mapView didUpdateToLocation:(CGPoint)location floorID:(NSUInteger)floorID;

/**
 Tells the delegate that the map view was unable to retrieve a location value.
 @param mapView The map view that had the location update.
 @param error The error object containing the reason the location could not be retrieved
 */
- (void)mapView:(PWMapView *)mapView didFailToUpdateLocationWithError:(NSError *)error;


///------------------
/// @name Scroll View
///------------------

/**
 Tells the delegate when the map view receives a single-tap.
 @param mapView The mapView that received the single-tap.
 @param gestureRecognizer The single-tap gesture recognizer that recognized the tap.
 */
- (void)mapView:(PWMapView *)mapView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer;

/**
 Tells the delegate that the map view’s zoom factor changed.
 @param mapView The `PWMapView` object whose zoom factor changed.
 */
- (void)mapViewDidZoom:(PWMapView *)mapView;

/**
 Tells the delegate when the user scrolls the content view within the receiver
 @param mapView The `PWMapView` object in which the scrolling occurred
 */
- (void)mapViewDidScroll:(PWMapView *)mapView;

/**
 Tells the delegate when the map view is about to start scrolling the content.
 @param mapView The `PWMapView` object that is about to scroll the content view.
 @discussion The delegate might not receive this message until dragging has occurred over a small distance.
 */
- (void)mapViewWillBeginDragging:(PWMapView *)mapView;

/**
 Tells the delegate when the user finishes scrolling the content.
 @param mapView The `PWMapView` object where the user ended the touch.
 @param velocity The velocity of the scroll view (in points) at the moment the touch was released.
 @param targetContentOffset The expected offset when the scrolling action decelerates to a stop.
 */
- (void)mapViewWillEndDragging:(PWMapView *)mapView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

/**
 Tells the delegate when dragging ended in the map view.
 @param mapView The `PWMapView` object that finished scrolling the content view
 @param decelerate `YES` if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation. If the value is `NO`, scrolling stops immediately upon touch-up.
 @discussion The map view sends this message when the user’s finger touches up after dragging content.
 */
- (void)mapViewDidEndDragging:(PWMapView *)mapView willDecelerate:(BOOL)decelerate;

/**
 Tells the delegate that the scroll view is starting to decelerate the scrolling movement.
 @param mapView The `PWMapView` object that is decelerating the scrolling of the content view.
 @discussion The map view calls this method as the user’s finger touches up as it is moving during a scrolling operation; the map view will continue to move a short distance afterwards.
 */
- (void)mapViewWillBeginDecelerating:(PWMapView *)mapView;

/**
 Tells the delegate that the map view has ended decelerating the scrolling movement
 @param mapView The `PWMapView` object that is decelerating the scrolling of the content view.
 @discussion The map view calls this method when the scrolling movement comes to a halt.
 */
- (void)mapViewDidEndDecelerating:(PWMapView *)mapView;

/**
 Tells the delegate when a scrolling animation in the map view concludes.
 @param mapView The `PWMapView` object that is performing the scrolling animation
 @discussion The map view calls this method at the end of its implementations of the `setCenterCoordinate:animated:` and setCenterCoordinate:zoomLevel:animated: methods, but only if animations are requested.
 */
- (void)mapViewDidEndScrollingAnimation:(PWMapView *)mapView;

@end