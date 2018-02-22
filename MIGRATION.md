# PWMapKit Migration Guide
## Upgrade from 3.2.x to 3.3.0

#### General

This release has some changes to support our new Location BLE provider.

##### Upgrade Steps

1. Open the `Podfile` from your project and change PWMapKit to include `pod 'PWMapKit', '3.3.0'`, then run `pod update` in the Terminal to update the framework. This will take in the latest version of PWLocation 3.3.x with latest version of PWCore 3.3.x.

## Upgrade from 3.1.x to 3.2.0:

#### General

Before v3.2.0 the `PWMapView` is a subclass of `UIView` and provides almost all the functions and properties like `MKMapView` does, from v3.2.0 `PWMapView` is changed to be subclass of `MKMapView` and you can use all the functions and properties that `MKMapView` has, as well as some convenient ones for indoor features.

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWMapKit include as `pod 'PWMapKit', '3.2.0'`, then run `pod update` in the Terminal to update the framework.

2. Search for `.userLocation` in whole project and replace the PWMapView`.userLocation` with PWMapView`.indoorUserLocation`, and don't forget change its type from `PWUserLocation` to `PWCustomLocation`.

3. Search for `.floor` in whole project and replace the PWMapView`.floor` with PWMapView`.currentFloor`.

4. Search for `didChangeUserTrackingMode` in whole project and replace PWMapViewDelegate.`mapView:didChangeUserTrackingMode:` with PWMapViewDelegate.`mapView: didChangeIndoorUserTrackingMode:`.

5. The `PWMapView.currentRoute` is changed to `readonly`, remove the code of setting `currentRoute` if possible.

6. Optional - replace the deprecated stuff according the change detail as below.

#### New

Set initial(or default) floor for the map via its delegate callback `[PWMapViewDelegate mapViewWillSetInitialFloor:]`.
Set initial display region for the map via its delegate callback `[PWMapViewDelegate mapViewWillSetCameraAfterLoadingBuilding:]`.

#### Change Detail

###### PWMapView

***IMPORTANT***

`PWMapView.userLocation` will not be user's indoor location, you can use `PWMapView.indoorUserLocation` instead.
`[PWMapViewDelegate mapView: didChangeUserTrackingMode:]` will not deliver tracking mode changes, you can use `[PWMapViewDelegate mapView: didChangeIndoorUserTrackingMode:]` instead.
`PWMapView.currentRoute` is changed to `readonly`.

*ADDED*

`[PWMapViewDelegate mapView: didChangeIndoorUserTrackingMode:]`, it's a replacement of `[PWMapViewDelegate mapView: didChangeTrackingMode:]`
`[PWMapViewDelegate mapViewWillSetCameraAfterLoadingBuilding:]`, it's using for setting an initial map region to display.
`[PWMapViewDelegate mapViewWillSetInitialFloor:]`, it's using for setting an initial floor to display.

*DEPRECATED*

`PWMapView.zoomLevel`, you can use `PWMapView.region` or `PWMapView.visibleMapRect` instead.
`[PWMapView getFloorByFloorId:]`, you can use `[PWMapView floorById:]` replace.
`[PWMapView setCenterCoordinate: zoomLevel: animated:]`, you can use any of`[PWMapView setCamera: animated:]`, `[PWMapView setRegion: animated:]`, `[PWMapView setVisibleMapRect: animated:]` or `[PWMapView setVisibleMapRect: edgePadding: animated:]` instead.
`[PWMapView navigateToCustomLocation:]` and `[PWMapView navigateToPointOfInterest:]`, you can use `[PWMapView setCamera:animated:]` or `[PWMapView setCenter:animated:]` instead.
`[PWMapView viewForPointOfInterest:]`, you can use `[PWMapView viewForAnnotation:]` instead.
`[PWMapView showPointsOfInterest:]`, you can use `[PWMapView showAnnotations: animated:]` instead.
`[PWMapView selectPointOfInterest:] animated:`, you can use `[PWMapView selectAnnotations: animated:]` instead.
`[PWMapView deselectPointOfInterest:] animated:`, you can use `[PWMapView deselectAnnotations: animated:]` instead.
`[PWMapView startUpdatingHeading]` and `[PWMapView stopUpdatingHeading]`, you can create your own `CLLocationManager` to get heading update.
`[PWMapView setFloor:]`, you can use `PWMapView.currentFloor` instead.

*REMOVED*

Long press on the map to drop a pin will no longer work and the `PWMapView.customLocation` is removed, but you can simply add it with `UILongPressGestureRecognizer` by yourself.

###### PWBuilding

*DEPRECATED*

`[PWBuilding buildingWithIdentifier:usingCache:completion:]`, you can use `[PWBuilding buildingWithIdentifier:completion:]` instead.
`[PWBuilding getFloorByFloorId:]`, you can use `[PWBuilding floorById:]` instead.

###### PWPointOfInterest

*Added*

The `PWPointOfInterest.imageURL`, it's an optional replacement of `image`.

###### PWCustomLocation (deprecated)

This class is deprecated, you can use `PWUserLocation` instead.
