#PWMapKit Changelog

##v2.3.1 (Monday, March 2nd, 2015)
* Fixed bug where when routing across multiple floors with a valid indoor location the build asset would get 'stuck' while the blue dot continued to move.
* Updated `PWRouteOverlayRenderer` initializer to accept a building overlay as part of initialization: `- (instancetype)initWithRouteOverlay:(PWRouteOverlay *)overlay buildingOverlay:(PWBuildingOverlay *)buildingOverlay`

##v2.3.0 (Thursday, January 29th, 2015)
* Added new "blue dot smoothing" functionality to provide a better user location tracking experience.
* Added `blueDotSmoothingEnabled` boolean property to `PWMapView` for turning blue dot smoothing on and off.
* Added `routeSnappingTolerance` enumeration property to `PWMapView` for turning off route snapping or setting a different tolerance.
* Added a **temporary** iOS 8 mapping zoom level workaround that will be removed as soon as Apple fixes their zoom level inadequacies.  Using the zoom level is explicit (not based on user-specified zoom scale) and is changed using the `-toggleZoomWorkaround` method.  The property `isUsingZoomWorkaround` indicates the current state of use of this workaround.  When in use, the workaround draws building assets at 4x their usual size and points of interest are repositioned accordingly.
* Added KVO notifications to the `PWMapView` property `indoorUserTrackingMode`.
* Added a `buildingAnnotations` property on `PWMapView` that contains all points of interest for the current building.
* Added `showBuildingAnnotation:animated:` method that focuses the map view to the provided annotation with optional animation. NOTE: This method will not work for object copies of POIs obtained from the building manager or elsewhere.  In order to find an annotation by identifier, name, or other property, simply search the `buildingAnnotations` property.  This method will automatically change floors on the map if necessary.  It will also zoom in to the maximum zoom level.
* `PWMapView` now honors the `maxZoomLevel` parameter for `PWBuildingAnnotation` objects
* You no longer need to manage the annotation image at the application level. `PWBuildingAnnotationView` now manages caching and loading of the annotation image internally.
* Building floors are now ordered in ascending order based on the `floorLevel` value.
* The `PWMapView` now only loads annotations for the current floor. The previous behavior was to load all building annotations and show/hide as necessary. `mapView.annotations` will now only return annotations for the current floor. If you would like to use all building annotations please use the `buildingAnnotations` property.
* You can now switch to `PWIndoorUserTrackingModeFollowWithHeading` while in routing mode. Note that the default indoor user tracking mode is still `PWIndoorUserTrackingModeFollow`.
* Consolidated all cached mapping data into one cache directory under `Library/Caches`.
* Mapping data cache expiration bumped to 24 hours. It was previously incorrectly set to 1.75 hours.
* Cleaned up public interfaces, removing extraneous and non-functional methods.
* Floor change no longer breaks the current indoor user tracking mode. See Wiki for additional details on user tracking behavior.
* Many bug fixes and performance enhancements
* Small updates to sample code

##v2.2.0 (Friday, October 31st, 2014)
* Promoting BETA 2 to GA candidate

##v2.2.0 BETA 2 (Wednesday, October 29th, 2014)
* Fixed issue where `imageURL` property on a PWBuildingAnnotation would sometimes return `nil`
* Fixed issue where POI icon image would not display on first load under certain memory constrained conditions
* Updated sample app to resolve to some routing centering issues

##v2.2.0 BETA (Monday, October 27th, 2014)
* `PWAnnotation` (protocol) renamed to `PWAnnotationProtocol`
* Added `PWAnnotationType`
* `PWBuilding`
* No longer conforms to NSCopying
* No longer conforms to NSSecureCoding
* Atomicized and write-protected properties
* Formalized building and campus identifier types
* `PWBuildingAnnotation` (protocool) renamed to `PWBuildingAnnotationProtocol`
* `PWBuildingFloor`
* Atomicized and write-protected properties
* Formalized building and campus identifier types
* `PWBuildingFloorReference`
* No longer conforms to NSCopying
* No longer conforms to NSSecureCoding
* Atomicized and write-protected properties
* `PWBuildingFloorResource`
* No longer conforms to NSCopying
* No longer conforms to NSSecureCoding
* Atomicized and write-protected properties
* `PWBuildingManager`
* Added method for fetching annotation types: `-(void)getBuildingAnnotationTypesWithCompletion:(PWBuildingAnnotationTypesHandler)completion`
* `PWBuildingOverlay`
* Atomicized properties
* `PWMapView`
* Added `-(void)willAppear` and `-(void)didAppear`. These properties should be used in conjunction with `UIViewController` methods.
* `PWMapViewDelegate` (protocol) renamed to `PWMapViewDelegateProtocol`
* `PWRouteStep`
* Added `annotations` property

##v2.1.2 (Tuesday, October 7th, 2014)
 * Fixed issue where building annotation callout view displaying would cause strange behavior on iOS 8
 * Small bug fixes and optimiziations

##v2.1.1 (Friday, September 18th, 2014)
 * General availability for native mapping SDK. See README.md for integration details.

##v2.1.1 BETA (Friday, August 15th, 2014)
 * Added support for labels in PWBuildingAnnotationView
 * Added support for real-time dynamic label occlusion
 * Added support for Phunware zoom levels. See POI details in MaaS portal to configure.

##v2.1.0 BETA (Friday, August 1st, 2014)
 * Removed location providers from PWMapKit and added to PWLocation SDK.
 * PWMapKit now has a dependency on PWLocation
 * Several bug fixes related to map positioning

##v2.0.3 BETA (Friday, July 10th, 2014)
 * Fixed crashing issue with `registerLocationManagerForIndoorLocationUpdates` method.
 * Fixed issue where multiple navigation annotations were appearing on the map view when scrolling
 * Fixed crashing issue in sample related to route view controller

##v2.0.2 BETA (Thursday, July 9th, 2014)
 * Native mapping beta release

##v1.0.0 (Wednesday, January 1st, 2014)
 * Initial release
