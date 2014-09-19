//
//  PWBuildingOverlay.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PWBuilding;
@class PWBuildingFloor;
@class PWMapDocument;

@protocol PWBuildingOverlayDelegate;

/**
 The `PWBuildingOverlay` object defines a specific type of annotation that represents a building on a map.
 */

@interface PWBuildingOverlay : NSObject <MKOverlay>

/**
 The building object associated with the overlay. (read-only)
 */
@property (nonatomic, readonly) PWBuilding *building;

/**
 The map document object associated with the overlay. (read-only)
 */
@property (nonatomic, readonly) PWMapDocument *currentDocument;

/**
 The array of map document resources associated with the overlay. (read-only)
 */
@property (nonatomic, readonly) NSArray *resources;

/**
 A Boolean flag indicating whether the building overlay has loaded.
 */
@property (nonatomic, assign, getter = isLoaded) BOOL loaded;

///-----------------------------
/// @name Accessing the Delegate
///-----------------------------

/**
 The receiver's delegate. The delegate must conform to the `MKMapViewDelegate` protocol.
 */
@property (nonatomic, weak) id<PWBuildingOverlayDelegate> delegate;

/**
 Initializes the overlay with the specified building. This method will automatically fetch and cache all required resources. The delegate will receive either a success or failure callback.
 @param building The building object to use when displaying building data on the map.
 @discussion Map assets are cached to disk, which enables the map view to display building information even while offline. If you want to clear a building data cache, please refer to `PWBuildingManager` for more information.
 */
- (instancetype)initWithBuilding:(PWBuilding *)building;

/**
 Initializes the overlay with the specified building and resources. This initializer does not make any network calls.
 @param building The building object to use when displaying building data on the map.
 @param resources The map document resources associated with this overlay. The map document resources must be associated with the building object.
 @discussion Map assets are cached to disk, which enables the map view to display building information even while offline. If you want to clear a building data cache, please refer to `PWBuildingManager` for more information.
 */
- (instancetype)initWithBuilding:(PWBuilding *)building resources:(NSArray *)resources;

/**
 Returns the floor currently being displayed. This array may be `nil` while the overlay is loading. Only attempt to access this property after receiving the `buildingOverlay:didFinishLoadingBuilding:` delegate callback.
 */
- (PWBuildingFloor *)currentFloor;

/**
 Change the floor currently being displayed to another PWBuildingFloor object. Passing the same floor will have no effect.
 @param floor The `PWBuildingFloor` object to set as the current floor.
 */
- (void)setCurrentFloor:(PWBuildingFloor *)floor;

@end


/**
 The `PWMapViewDelegate` protocol defines a set of optional methods that you can use to receive building-related update messages. Because many map operations require the `PWMapView` class to load data asynchronously, the map view calls these methods to notify your application when specific operations complete.
 
 Before releasing a `PWMapView` object for which you have set a delegate, remember to set that object’s delegate property to `nil`.
 */

@protocol PWBuildingOverlayDelegate <NSObject>

///----------------------------
/// @name Loading Building Data
///----------------------------

@optional

/**
 Tells the delegate that the specified overlay successfully changed the floor.
 @param overlay The building overlay object.
 @param floor The current floor object.
 */
- (void)buildingOverlay:(PWBuildingOverlay *)overlay didChangeFloor:(PWBuildingFloor *)floor;

/**
 Tells the delegate that the specified overlay successfully loaded necessary building data.
 @param overlay The building overlay object.
 @param building The building object that the overlay loaded.
 */
- (void)buildingOverlay:(PWBuildingOverlay *)overlay didFinishLoadingBuilding:(PWBuilding *)building;

/**
 Tells the delegate that the specified overlay was unable to load the building data.
 @param overlay The building overlay object.
 @param building The building object that the overlay tried to load.
 @param error Why the building data could not be loaded.
 */
- (void)buildingOverlay:(PWBuildingOverlay *)overlay didFailToLoadBuilding:(PWBuilding *)building error:(NSError *)error;

@end

extern NSString * const PWBuildingOverlayDidFinishLoadingNotification;
extern NSString * const PWBuildingOverlayDidFailToLoadNotification;