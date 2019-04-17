PWMapKit Samples for iOS
====================

## PhunMaps

### Overview
- Display map with building.
- Search for points of interest in building.
- Route from current location to a selected point of interest.

### Usage
- Go to *./PhunMaps* directory in Terminal and run `pod update`.
- Open the project with Xcode.
- Fill out `applicationId`, `accessKey`, `signatureKey` and `buildingId` in *DefaultConfiguration.plist*.
- Build the application and run it on your device.

## MapScenarios

### Overview
- A couple of different use cases in both Swift and Objective C.
- Each use case has a ViewController.

### LoadBuildingViewController
- Display your building on the map

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`

##### Sample code in [LoadBuildingViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/LoadBuildingViewController.swift):

```
PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
	guard let building = building else {
		// Error handle
		return
	}

	self?.mapView.setBuilding(building, animated: true, onCompletion: nil)
}
```

### BluedotLocationViewController
- Display current location in your building as reported by location provider

##### Usage:
- Configure location provider on building's edit page in Maas portal, then configure for each floor
- Fill out applicationId, accessKey, signatureKey, and buildingIdentifier in the ViewController

##### Sample code in [BluedotLocationViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/BluedotLocationViewController.swift):

```
self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
	// Handle error

	self?.locationManager.delegate = self
	if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
		self?.locationManager.requestWhenInUseAuthorization()
	} else {
		self?.startManagedLocationManager()
	}
})
```

### CustomPOIViewController
- Add a point of interest to the map programmatically

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Specify a `poiLocation` that is within the bounds of your building
- Optionally fill out configuration values in `addCustomPointOfInterest` such as `poiFloorId`, `poiTitle` etc.

##### Sample code in [CustomPOIViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/CustomPOIViewController.swift):

```
func addCustomPointOfInterest() {
	let poiLocation = CLLocationCoordinate2DMake(30.359931, -97.742507)
	let poiTitle = "Custom POI"

	// If the image parameter is nil, it will use the POI icon for any specified `pointOfInterestType`. If no image is set and no `pointOfInterestType` is set, the SDK will use this default icon: https://lbs-prod.s3.amazonaws.com/stock_assets/icons/0_higher.png
	let customPOI = PWCustomPointOfInterest(coordinate: poiLocation, floor: mapView.currentFloor, title: poiTitle, image: nil)

	customPOI?.isShowTextLabel = true

	if let customPOI = customPOI {
		mapView.addAnnotation(customPOI)
	}
}
```

### LocationModesViewController
- Button to switch the map's camera mode to follow current location, not follow current location, or follow current location and align the camera to the device compass

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Tap the arrow button to visualize the various location modes

##### Sample code in [LocationModesViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/LocationModesViewController.swift):

Change tracking mode:

```
@IBAction func trackingModeButtonTapped(_ sender: Any) {
    switch mapView.trackingMode {
    case .none:
        mapView.trackingMode = .follow
    case .follow:
        mapView.trackingMode = .followWithHeading
    case .followWithHeading:
        mapView.trackingMode = .none
    }
}
```

Update UI:

```
extension LocationModesViewController: PWMapViewDelegate {

    func mapView(_ mapView: PWMapView!, didChangeIndoorUserTrackingMode mode: PWTrackingMode) {
        switch mode {
        case .none:
            trackingModeButton.image = // .emptyTrackingImage(color: .blue)
        case .follow:
            trackingModeButton.image = // .filledTrackingImage(color: .blue)
        case .followWithHeading:
            trackingModeButton.image = // .trackWithHeadingImage(color: .blue)
        }
    }
}
```

### RoutingViewController
- Route to a point of interest as soon as location is acquired
- Route configuration such as the color of path, show join point etc.

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Add at least one point of interest to your building in the Maas portal, and connect it with a segment to the nearest waypoint
- Optionally specify a `destinationPOIIdentifier` to route to, which can be found on the point of interest's `Edit` page. If left as `0`, it will use the first point of interest found.
- Custom route display by giving a `PWRouteUIOptions` as second parameter of `mapView.navigate(with: route, options: routeUIOptions)`.

##### Sample code in [RoutingViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/RoutingViewController.swift):

```
PWRoute.createRoute(from: mapView.indoorUserLocation, to: destinationPOI, accessibility: false, excludedPoints: nil, completion: { [weak self] (route, error) in
	guard let route = route else {
		// handle error
		return
	}

	let routeOptions = PWRouteUIOptions()
	self?.mapView.navigate(with: route, options: routeOptions)
})
```

### SearchPOIViewController
- View list of points of interest in table
- Filter points of interest list by title
- Select point of interest and view its location in your building

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Add at least one point of interest to your building in the Maas portal
- Tap search bar to view and filter list of selectable points of interest

##### Sample code in [SearchPOIViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/SearchPOIViewController.swift):

```
var pointOfInterest: PWPointOfInterest!

// ... find the `pointOfInterest ` what you want

// Switch the floor on which the POI is
if mapView.currentFloor.floorID != pointOfInterest.floorID {
	let newFloor = mapView.building.floor(byId: pointOfInterest.floorID)
	mapView.currentFloor = newFloor
}

// Mark the POI selected
mapView.selectAnnotation(pointOfInterest, animated: true)
```

### LocationSharingViewController
- Show current location in building
- Show current location of other users of the app in the same building on the map

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Tap "Settings" button to change device name or type
- Required to have at least two unique device identifiers with blue dot in the same building to see usage

##### [Sample code](./MapScenarios/LocationSharing.md)

### TurnByTurnCollectionView
- Show route instructions in carousel UI

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`

##### [Sample code](./MapScenarios/TurnByTurn.md)

### VoicePromptRouteViewController
- Read route instructions out loud
- Can read instructions as you swipe through them or traverse them

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`

##### [Sample code](./MapScenarios/VoicePrompt.md)

### WalkTimeViewController
- Show estimated walk time of an indoor route based on route distance and user speed

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`

##### [Sample code](./MapScenarios/WalkTime.md)

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.
Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
