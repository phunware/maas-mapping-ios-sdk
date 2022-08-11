PWMapKit SDK for iOS
================
[![Version](https://img.shields.io/cocoapods/v/PWMapKit.svg?style=flat-square)](https://cocoapods.org/pods/PWMapKit) [![License](https://img.shields.io/cocoapods/l/PWMapKit.svg?style=flat-square)](https://cocoapods.org/pods/PWMapKit) [![Platforms](https://img.shields.io/cocoapods/p/PWMapKit?style=flat-square)](https://cocoapods.org/pods/PWMapKit) [![Twitter](https://img.shields.io/badge/twitter-@phunware-blue.svg?style=flat-square)](https://twitter.com/phunware)

This is Phunware's Mapping SDK for use with its Multiscreen-as-a-Service platform. It is a comprehensive indoor/outdoor mapping and wayfinding solution that allows easy integration with Phunware's maps and location-based services. Visit http://maas.phunware.com for more details and to sign up.

Requirements
------------
- PWLocation 3.12.x
- PWCore 3.12.x
- iOS 13.0 or greater
- Xcode 12 or greater

Installation
------------
### CocoaPods
It is required to use [CocoaPods](http://www.cocoapods.org) 1.10 or greater to integrate the framework. Simply add the following to your Podfile:

````ruby
pod 'PWMapKit'
````

Documentation
------------
Documentation is included in the Documents folder in the repository as both HTML and as a .docset. You can also find the latest documentation here: http://phunware.github.io/maas-mapping-ios-sdk

## Usage
The primary use of the components of PWMapKit revolve around creating a map view, displaying points of interest, showing the user's location and indoor routing.

### Setup
Make sure your app is correctly [set up](https://github.com/phunware/maas-core-ios-sdk#application-setup) before you start working on map integration.

## Location Permissions
Location authorization of "When In Use" or "Always" is required for a PWLocationManager to function normally. Please follow [Apple's Best Practices](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services) for requesting location permissions. Do not attempt to use a PWLocationManager if the user does not provide location authorization as this can lead to unexpected behavior.

### Adding Map View
```swift
// Load a building
PWBuilding.building(identifier: <BUILDING_IDENTIFIER>) { result in
    switch result {
    case .success(let building):
        // Do something with the buliding object
        ...
            
    case .failure(let error):
        // Failed to load the building
        ...
    }
}

...

// Show the building on the map
let mapView = PWMapView(frame: <FRAME>)
mapView.delegate = self
self.view.addSubview(mapView)

map.setBuilding(<BUILDING>, animated: <ANIMATED>) { (error) in     
    // Building should be on the map
}
```

### Register Location Provider
The PWMapView can display a user location on the map if a location provider is registered with the PWMapView. The location providers are in the PWLocation framework, and each different provider requires different steps to set up (see readme here https://github.com/phunware/maas-location-ios-sdk to view setup examples of all different provider options). Once the location provider is initialized, the following call may be used to register the provider with the PWMapView:

```swift
mapView.register(<MANAGER_OBJECT>)
```

NOTE: If using a virtual beacon provider such as Mist or Beacon Point, the "Uses Bluetooth LE accessories" background mode must be enabled in the "Capabilities" tab of your project's settings.

### Routing
```swift
let routeOptions = PWRouteOptions(accessibilityEnabled: false,
                                  landmarksEnabled: false,
                                  excludedPointIdentifiers: nil)

PWRoute.createRoute(from: <START_POINT>,
                    to: <END_POINT>,
                    options: routeOptions) { result in
    switch result {
    case .success(let route):
        // Plot the route on the map
        mapView.navigate(with: route)
    
    case .failure(let error):
        // Failed to create a route
        ...
    }    
}
```

## Attribution
PWMapKit uses the following third-party dependencies:

<table>
  <tr>
  <th style="text-align:center;">Component</th>
  <th style="text-align:center;">Description</th>
  <th style="text-align:center;">License</th>
  </tr>
  <tr>
    <td><a href="https://github.com/samvermette/SVPulsingAnnotationView">SVPulsingAnnotationView</a></td>
    <td>
     A customizable MKUserLocationView replica for your iOS app.
    </td>
    <td style="text-align:center;""><a href="https://github.com/samvermette/SVPulsingAnnotationView/blob/master/LICENSE.txt">MIT</a>
    </td>
  </tr>
  <tr>
    <td><a href="https://github.com/tumblr/TMCache">TMCache</a></td>
    <td>
     Fast parallel object cache for iOS and OS X.
    </td>
    <td style="text-align:center;""><a href="https://github.com/tumblr/TMCache/blob/master/LICENSE.txt">Apache 2.0</a>
    </td>
  </tr>
</table>

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms
