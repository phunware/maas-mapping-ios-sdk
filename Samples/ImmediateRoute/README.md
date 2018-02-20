ImmediateRoute Sample for iOS
====================

### Usage

The primary use of the components for this sample revolve around creating a map view to show route from current location to a specified destination POI on the map.

*`NOTE: The route direction is displayed after user's location is acquired.`*

### Configuration

1. Go to the `Samples/ImmediateRoute` directory with `Terminal` in this project, then run `pod install`.
2. The `ImmediateRoute.xcworkspace` should be gernated if the previous step is done successfully. Open the xcworkspace in Xcode.
3. Open the `AppDelegate.swift` file in Xcode and put the right value for the constants below:

````
let applicationId = "<MaaS App ID>"
let accessKey = "<MaaS Access Key>"
let signatureKey = "<Signature Key>"
````

Open `ViewController.swift` to: 

1. replace the `buildingIdentifier` of `0`
2. replace the `destinationPOIIdentifier` of `0`

