LoadMap Sample for iOS
====================

### Usage

The primary use of the components for this sample revolve around creating a map view to show the building on the map

### Configuration

1. Go to the `Samples/LoadMap` directory with `Terminal` in this project, then run `pod install`.
2. The `LoadMap.xcworkspace` should be gernated if the previous step is done successfully. Open the xcworkspace in Xcode.
3. Open the `AppDelegate.swift` file in Xcode and put the right value for the constants below:

````
let applicationId = "<MaaS App ID>"
let accessKey = "<MaaS Access Key>"
let signatureKey = "<Signature Key>"
````

Open `ViewController.swift` to replace the `buildingIdentifier` of `0`

### Adding Map View

### ViewController.m

````
// Load a building
PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
	// Get the building object here
            self?.mapView.setBuilding(building)

            if let buildingIdentifier = self?.buildingIdentifier {
                let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingIdentifier)

                DispatchQueue.main.async {
                    self?.mapView.register(managedLocationManager)
                }
            }
}

...

// Show the building on the map
self?.mapView.setBuilding(building)

if let buildingIdentifier = self?.buildingIdentifier {
    let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingIdentifier)

    DispatchQueue.main.async {
        self?.mapView.register(managedLocationManager)
    }
}
````
