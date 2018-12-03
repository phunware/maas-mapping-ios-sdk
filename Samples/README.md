PWMapKit Samples for iOS
====================

## PhunMaps

### Overview
- Display map with building
- Search for points of interest in building
- Route from current location to a selected point of interest

## MapScenarios

### Overview
- Six different use cases in both Swift and Objective C
- Each use case functional within one ViewController

### LoadBuildingViewController
- Display your building on the map

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`

### BluedotLocationViewController
- Display current location in your building as reported by location provider

##### Usage:
- Configure location provider on building's edit page in Maas portal, then configure for each floor
- Fill out applicationId, accessKey, signatureKey, and buildingIdentifier in the ViewController

### CustomPOIViewController
- Add a point of interest to the map programmatically

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Specify a `poiLocation` that is within the bounds of your building
- Optionally fill out configuration values in `addCustomPointOfInterest` such as `poiFloorId`, `poiTitle` etc.

### LocationModesViewController
- Button to switch the map's camera mode to follow current location, not follow current location, or follow current location and align the camera to the device compass

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Tap the arrow button to visualize the various location modes

### RoutingViewController
- Route to a point of interest as soon as location is acquired
- Route configuration such as the color of path, show join point etc.

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Add at least one point of interest to your building in the Maas portal, and connect it with a segment to the nearest waypoint
- Optionally specify a `destinationPOIIdentifier` to route to, which can be found on the point of interest's `Edit` page. If left as `0`, it will use the first point of interest found.
- Custom route display by giving a `PWRouteUIOptions` as second parameter of `mapView.navigate(with: route, options: routeUIOptions)`.

### SearchPOIViewController
- View list of points of interest in table
- Filter points of interest list by title
- Select point of interest and view its location in your building

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Add at least one point of interest to your building in the Maas portal
- Tap search bar to view and filter list of selectable points of interest

### LocationSharing
- Show current location in building
- Show current location of other users of the app in the same building on the map

##### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`
- Tap "Settings" button to change device name or type
- Required to have at least two unique device identifiers with blue dot in the same building to see usage


Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.
Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
