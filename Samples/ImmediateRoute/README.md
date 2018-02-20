ImmediateRoute Sample for iOS
====================

### Usage

The primary use of the ImmediateRoute sample demonstrates creating a map view to show the building with points of interest and allowing users to route from current location to a specific point.

### Configuration

1. Go to the `Samples/ImmediateRoute` directory with `Terminal` in this project, then run `pod install`.
2. The `ImmediateRoute.xcworkspace` should be generated if the previous step is done successfully. Open the xcworkspace in Xcode.
3. Open `MapViewController.swift` to replace the `/*StartPoint*/`, `/*EndPoint*/` and `/*CurrentLocationToEndPoint*/` with the POIs as you want.
4. Open the `DefaultConfiguration.plist` file in Xcode and plug your Maas organization values into the corresponding fields below:

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
