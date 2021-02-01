//
//  PWBuildingOverlay.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWBuilding;
@class PWFloor;
@class PWMapDocument;

@protocol PWBuildingOverlayDelegateProtocol;

/**
 The `PWBuildingOverlay` object defines a specific type of annotation that represents a building on a map.
 */

@interface PWBuildingOverlay : NSObject<MKOverlay>

/**
 The building object associated with the overlay. (read-only)
 */
@property (readonly) PWBuilding *building;

/**
 The map document object associated with the overlay. (read-only)
 */
@property (readonly) PWMapDocument *currentDocument;

/**
 The floor currently being displayed. This value may be 'nil' while the building overlay is loading. Changing the floor to the same floor will have no effect. Attempt to access this property only after receiving the `buildingOverlay:didFinishLoadingBuilding:` delegate callback.
 */
@property (nonatomic) PWFloor *currentFloor;

/**
 The array of map document resources associated with the overlay. (read-only)
 */
@property (readonly) NSArray *resources;

/**
 A Boolean flag indicating whether the building overlay has loaded.
 */
@property (getter = isLoaded) BOOL loaded;

///-----------------------------
/// @name Accessing the Delegate
///-----------------------------

/**
 The receiver's delegate. The delegate must conform to the `PWBuildingOverlayDelegateProtocol` protocol.
 */
@property (nonatomic, weak) id<PWBuildingOverlayDelegateProtocol> delegate;

/**
 Initializes the overlay with the specified building. This method will automatically fetch and cache all required resources. The delegate will receive a success or failure callback.
 @param building The building object to use when displaying building data on the map.
 @param floor The initial floor.
 @discussion Map assets are cached to disk, which enables the map view to display building information even while offline. For clearing a building data cache.
 */
- (instancetype)initWithBuilding:(PWBuilding *)building initialFloor:(PWFloor *)floor;

@end

/**
 The `PWBuildingOverlayDelegateProtocol` protocol defines a set of optional methods that you can use to receive building-related update messages. Since many overlay operations require the `PWBuildingOverlay` class to load data asynchronously, the overlay calls these methods to notify your application when specific operations complete.
 */

@protocol PWBuildingOverlayDelegateProtocol <NSObject>

/**
 The `PWBuildingOverlayDelegateProtocol` protocol defines a set of optional methods that you can use to receive building-related update messages. Because many map operations require the `PWMapView` class to load data asynchronously, the map view calls these methods to notify the application when specific operations complete.
 */

///----------------------------
/// @name Loading Building Data
///----------------------------

@optional

/**
 Tells the delegate that the specified overlay successfully changed the floor.
 @param overlay The building overlay object.
 @param floor The current floor object.
 */
- (void)buildingOverlay:(PWBuildingOverlay *)overlay didChangeFloor:(PWFloor *)floor;

/**
 Tells the delegate that the specified overlay was unable to load the building data.
 @param overlay The building overlay object.
 @param floor The floor object that the overlay tried to load.
 @param error Why the building data could not be loaded.
 */
- (void)buildingOverlay:(PWBuildingOverlay *)overlay didFailedToChangeFloor:(PWFloor *)floor error:(NSError *)error;

@end
