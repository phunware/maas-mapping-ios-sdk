#PWMapKit Changelog

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