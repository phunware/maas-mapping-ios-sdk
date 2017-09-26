PhunMaps Sample for iOS
====================

### Usage

The primary use of the PhunMaps sample demonstrates creating a map view to show the building with points of interest and allowing users to route from current location to a specific point.

### Configuration

1. Go to the `Samples/PhunMaps` directory with `Terminal` in this project, then run `pod install`.
2. The `PhunMaps.xcworkspace` should be generated if the previous step is done successfully. Open the xcworkspace in Xcode.
3. Open the `DefaultConfiguration.plist` file in Xcode and plug your Maas organization values into the corresponding fields below:

```
appId
accessKey
signatureKey

buildings ->
identifier
```

```swift
let buildingId = ConfigurationManager.shared.currentConfiguration.buildingId
PWBuilding.building(withIdentifier: buildingId!) { [weak self] (building, error) in
   ...
   let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingId!)
   DispatchQueue.main.async {
       self?.mapView.register(managedLocationManager)
   }
   ...
}
```

### Adding Map View

### MapViewController.swift

```swift
// Load a building
PWBuilding.building(withIdentifier: buildingId!) { [weak self] (building, error) in
	// Get the buliding object here
	<#building#>					
}

...

// Show the building on the map
let mapView = PWMapView()
mapView.delegate = self
view.addSubview(mapView)

mapView.setBuilding(building)
```

### Search for points of interest

### DirectoryController.swift

```swift
floor.pointsOfInterest(of:<#pointOfInterestType#> containing:<#searchTerm#>)
```

### Routing between two POIs

### MapViewController.swift

```swift
// Initializing a route
 PWRoute.createRoute(from: startPoint, to: endPoint, accessibility: false, excludedPoints: nil, completion: { [weak self] (route, error) in

}

 ...

 // Displaying a route on the map
 mapView.navigate(with: route)
 ```
