#PWMapKit Changelog

##v3.1.6.2 (Friday, Sep 8th, 2017)
* Update to PWLocation 3.1.7.1

##v3.1.6.1 (Wednesday, Sep 6th, 2017)

* Add two new delegate callback for PWMapView:
	* - (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
	* - (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view;

##v3.1.6 (Wednesday, Aug 30th, 2017)

* Update to PWLocation 3.1.7

##v3.1.5 (Thursday, Aug 17th, 2017)

* Fix route issue with a curved manuever.
* Fix orientation issue when the heading service is turned on by developer.


##v3.1.4 (Monday, Jun 26th, 2017)

* Improve route calculator for finding shortest route path.
* User experience improvement by getting more stable route orientation.
* Add support for escalator with routing.
* Bug fixes
	* Map floor rotates incorrectly while each floor has different rotation angle.
	* Start/End of route has empty title.
	* Changing map zoom levels for POI's are not reflected


##v3.1.3 (Wednesday, Apr 19th, 2017)

* Bug fixes
	* Can route from user location on first user location update
	* PWCustomLocation public initialization method

##v3.1.2 (Wednesday, Apr 12th, 2017)

* New features
	* Add PWCustomPointOfInterest.
	* Create route API can now accept points to exclude.

* Performance improvement
	* Significantly reduce times of zoom level calculator.
	* Routing with tracking mode `Follow Me With Heading` improvement.
	* Map load/render time lowered.

* Bug Fixes
	* Floor change intermittent failures.
	* Route not found from current location to POI.

* Other
	* Deprecated startPointOfInterest and endPointOfInterest properties in PWRouteInstruction, replaced with startPoint and endPoint.
	* Deprecated `initWithLatitude:` method in PWCustomLocation, replaced with `initWithCoordinate:`.
	* Create PWMapPoint protocol and make POIs, waypoints, and custom location conform to it.

##v3.1.1 (Tuesday, Mar 28th, 2017)

* Enable `zoomLevel` property in PWMapView.
* Route behavior improvements:
	* Make `Follow Me` as default tracking mode.
	* Automatically enable `Follow me` tracking mode when device is close to current route instruction.
	* User can swipe to view future/past route instructions when `Follow Me` is enabled.

* Bug fixes:
	* Use the cached bundle instead when network is unavailable.
	* Wrong route instruction text for elevator.
	* The callback `mapView:didDeselectBuildingAnnotationView:` never be fired.
	* The PointOfInterestType image is always nil.

##v3.1.0 (Friday, Jan 27th, 2017)

* Performance improvement for loading building data with bundle instead of numbers of API call.
* Deprecated the API `+ (void)buildingWithIdentifier:(NSInteger)identifier usingCache:(BOOL) caching completion:(void(^)(PWBuilding *building, NSError *error))completion __deprecated;`  in PWBuilding, which is replaced by new API `+ (void)buildingWithIdentifier:(NSInteger)identifier completion:(void(^)(PWBuilding *building, NSError *error))completion;`.
* Bug fix: Sometimes occupant can not zoom in as far as before once they have zoomed out on the map.

##v3.0.4 (Monday, November 28th, 2016)

* Avoid forcing map to current floor on navigation mode.

##v3.0.3 (Tuesday, November 8th, 2016)

* Add observable/callback method for `trackingMode` in PWMapView.
* Support adding custom annotation/overlay in PWMapView.
* Bug fixes.

##v3.0.2 (Tuesday, October 25th, 2016)

* Fix the issue of memory leak.
* Add/improve APIs for supporting ADA.

##v3.0.1 (Friday, October 7th, 2016)

* Public more `PWMapKit` delegate methods and APIs which `MKMapView` has.
* Add `metaData` property in `PWPointOfInterest`.

##v3.0.0 (Monday, July 25th, 2016)

* API completely redesign.
* Add light weight UI view controllers.
* Performance improvements (PDF Tiling, Map/Building isolation, Memory reduction).
* Bug fix for crashes result from HTTP response handler.


##v2.6.0 (Wednesday, September 30th, 2015)

* Updated framework to leverage PWCore v2.0.0

* Updated internal networking interfaces to use HTTPS endpoints

* Fixed a race condition that would occur when trying to load building assets

##v2.5.1 (Thursday, July 20th, 2015)

* Added ability for developer to control whether or not the maneuver change is animated. See `- (BOOL)mapViewShouldAnimateAutomaticRouteManeuverChange:(PWMapView *)mapView` delegate method.

* Added new method to PWMapView, `-(void)setRouteManever:(PWRouteManever *)maneuver animated:(BOOL)animated` that allows you to control whether or no the maneuver is animated when switching.

  **NOTE**: The old method, `-(void)setRouteManever:(PWRouteManever *)maneuver` no longer animates the maneuver change.

* Added property to `PWDirectionsOptions` called `excludedPointIdentifiers`. Specify an array of point identifiers that you would like to exclude from routing. Please see `PWDirectionsOptions` header for more information.

* Fixed an issue where automatic maneuver switching would not work with the GPS location provider if the floor identifier was unknown. Now switches the to closest maneuver on a given floor.

* Fixed an issue where toggling the zoom workaround on/off would no longer preserve the center position.

* Instrumented SDK with mapping & navigation analytics. Analytics are disabled by default. See `PWMapKitAnalytics` for more information and to enable.

* Updating zoom workaround to with iOS 8.4 and all subsequent iOS 8 versions. Note that the zoom workaround will not work on iOS 9 since iOS 9 resolves the issue.

##v2.5.0 (Thursday, June 4th, 2015)

* Added support for turn-by-turn directions. Turn-by-turn maneuvers can be accessed by accessing the `maneuvers` property on a `PWRoute` object. You can plot a route maneuver on a `PWMapView` intance by calling `setRouteManeuver:` with a valid `PWRouteManeuver` object. All previous route behavior is still present and unaffected. Please see the turn-by-turn sample as an example of how to implement turn-by-turn.

  **NOTE**: You will need to plot a route maneuever in order to enter turn-by-turn mode.

* Route maneuvers switch automatically when location upates are available and the indoor user tracking mode is set to `PWIndoorUserTrackingModeFollow` or `PWIndoorUserTrackingModeFollowWithHeading`. You can manually set route maneuvers if desired but that will set the indoor user tracking mode to `PWIndoorUserTrackingModeNone`.

* Added new class, `PWRouteManeuever`. A route maneuver encapsulates information related to given maneuver such as turn direction, distance and other information.

* Route steps are now automatically selected by the SDK in response to user initiated floor changes or location updates. A new callback has been created when a route step changes.

* Added `PWMapView` delegate callback `mapView:didChangeRouteStep:`. This method is called whenever the `PWRouteStep` being displayed by the map view changes.

* Added `PWMapView` delegate callback `mapView:didChangeRouteManeuver:`. This method is called whenever the `PWRouteManeuver` being displayed by the map changes.

* Routing and maneuver overlays now use the `mapView.tintColor` property when rendering their overlays.

* When registering a `PWGPSLocationManager` with the map view the location will now show on all floors regardless of whether or not there is a valid `floorIDMapping` match.

##v2.5.0 - BETA 1 (Friday, May 15th, 2015)

* Beta release of turn-by-turn features

##v2.4.1 (Monday, April 27th, 2015)

* Fixed issue where `didFailToLoadBuilding:` was not being called while in airplane mode on initial launch with no cached data.
* Fixed a memory issue where route steps and segments were not being released when destroying a `PWMapView` instance.
* Fixed issue where `PWMapView` delegate method `mapView:didChangeIndoorUserTrackingMode:` would not be called in certain instance.
* Fixed regression which made `PWBuildingAnnotationView` hard to tap.
* Added horizontal accuracy bubble to indoor blue dot view.
* Added discreet sample apps for Pin Drop, Zoom Workaround, POI Management

##v2.4.0 (Friday, March 13th, 2015)

* Added the ability to enable and disable annotation zoom levels. See the `annotationZoomLevelsEnabled` property on `PWMapView` for more information.
* Added the ability for users to add and remove `PWBuildingAnnotation` objects to and from the map view. NOTE: When adding or removing annotations, only `annotationID` equality will be checked.
* Fixed a bug where inaccessible routes were sometimes returned for accessible-only requests.
* Fixed a bug where routing between two points on the same floor would sometimes return a route that spanned multiple floors.
* Fixed a bug where setting `showsIndoorUserLocation` on `PWMapView to ‘NO’ would not hide the blue dot.
* Fixed a bug where toggling route snapping tolerance would not resume route snapping when reenabled.
* Added the ability to stop loading a building. See `stopLoadingBuilding` method on `PWMapView` for more information.
* Fixed a bug where memory for the routing graph wasn't being released when the `PWMapView` instance was being deallocated.
* Fixed a bug where building assets would get ‘stuck’ while the user’s blue dot continued to move during a route across multiple floors (with a valid indoor location).
* Added a flag to `PWBuildingAnnotationProtocol`, `occlusionEnabled`. This flag determines whether the annotation label for a given annotation will be occluded by other labels. If `occlusionEnabled` is set to `NO`, the annotation label will **always** be visible.
* `PWMapView` now correctly calls the delegate callback ` -mapView:didChangeIndoorUserTrackingMode:`.
* Added options that allow routing from any point of interest, user location or dropped pin annotation to any other point of interest, user location or dropped pin annotation (in other words, any type of route endpoint is now allowed on either end of the route). See `PWDirections` and `PWDirectionsWaypointProtocol` for more information.
* Enhanced routing functionality now uses a synchronous directions request interface. The former asynchronous request/response model is still supported but will be deprecated.
* Renamed `PWBuildingOverlayDelegate` to `PWBuildingOverlayDelegateProtocol`.
* Deprecated the old indoor location manager registration interface in favor of a more simply named method with accompanying unregister method.
* Removed the `-setCurrentFloor:` PWMapView property mutator declaration and removed the `readonly` attribute of the property.

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
