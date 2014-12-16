#PWMapKit Changelog

##v2.3.0 BETA 6 (Thursday, December 15th, 2014)
* Adding KVO notifications to indoorUserTrackingMode
* Floor change no longer breaks the current indoor user tracking mode. See Wiki for additional details on user tracking behavior.

##v2.3.0 BETA 5 (Thursday, December 4th, 2014)
* Fixed pagination issue when fetching route points
* Exposing `buildingAnnotations` property on PWMapView. This propert contains all `PWBuildingAnnotation` objects associated with the map view
* Added method, `showBuildingAnnotation:animated:` that focuses the map view to the provided annotation with optional animation. NOTE: This method will not work for object copies of POIs obtained from the building manager or elsewhere.  In order to find an annotation by identifier, name, or other property, simply search the `buildingAnnotations` property.  This method will automatically change floors on the map if necessary.  It will also zoom in to the maximum zoom level.

##v2.3.0 BETA 4 (Wednesday, December 3rd, 2014)
* Fixed an issue where calling `showAnnotations:animated:` would cause a crash
* Fixed an issue where the annotations would not appear at the appropriate zoom level
* PWMapView now honors the maxZoomLevel parameter for PWBuilding annotations objects
* Fixed an issue with the `PWUserTrackingBarButtonItem` where it wouldn't allow you to switch tracking modes while in routing mode
* Exposing PWMapView+ZoomWorkaround.h which has a method to convert to and from zoom workaround coordinate system

##v2.3.0 BETA 3 (Tuesday, December 2nd, 2014)
* Fixed issue where building annotation views would disappear from the map (introduced in earlier betas).
* You no longer need to manage the annotation image at the application level. `PWBuildingAnnotationView` now manages caching and loading of the annotation image internally. 
* Building floors are now ordered in ascending order, based on the `floorLevel` value.

##v2.3.0 BETA 2 (Monday, November 24th, 2014)
* Fixed issue where camera would not properly center on the blue dot while zoom workaround was enabled
* The `PWMapView` now only loads annotations for the current floor. Previous behavior was to load all building annotations and show/hide as necessary. mapView.annotations will now only return annotations for the current floor. If you would like to fetch all building annotations please use the `PWBuildingManager` class.
* Fixed issue where routing annotation titles would sometimes be `nil`.
* You can now switch to `PWIndoorUserTrackingModeFollowWithHeading` while in routing mode. Note that the default indoor user tracking mode is still `PWIndoorUserTrackingModeFollow`.
* Fixed an issue where annotation labels wouldn't appear when switching floors.

##v2.3.0 BETA (Wednesday, November 19th, 2014)
* Added iOS 8 mapping zoom level workaround. To enable the workaround, call `[PWMapKit setShouldUseZoomWorkaround:YES];`. This workaround is **temporary** and will be removed/internalized as soon as Apple fixes their zoom level issues.
* Consolidated all cached mapping data into one cache directory under Library/Caches
* Fixed bug where annotations on the map wouldn't call `mapView:didSelectAnnotationView:`.
* Fixed issue where the annotation labels would overlap when changing floors.
* Fixed issue where `PWRouteStep` objects would sometimes incorrectly have their floorID set to 0.
* Fixed an issue with offline routing where trying to find neighboring point would sometimes cause an exception if that point did not have any connecting segments
* Mapping data TTL cache bumped to 24h. It was previously incorrectly set to 1.75 hours.
* Cleaned up public interfaces, removing extraneous and non-functional methods

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