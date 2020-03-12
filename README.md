PWMapKit SDK for iOS
====================

> Version 3.9.1

**PWMapKit** is a comprehensive indoor mapping and wayfinding SDK that allows easy integration with Phunware's indoor maps and location-based services.  Visit http://maas.phunware.com/ for more details and to sign up.


## Requirements

- PWLocation 3.8.0 and above (Automatically included when pod install PWMapKit)
- PWCore 3.8.x (Automatically included when pod install PWMapKit)
- iOS 10.0 or greater
- Xcode 11 or greater


## Installation

* Phunware recommends using [CocoaPods](http://www.cocoapods.org) to integrate the framework. Simply add

	`pod 'PWMapKit'`

	to your podfile, then the dependencies of `PWCore` and `PWLocation` are automatically added.
    
    Alternatively you could specify 
    
    `pod PWMapKit/NoAds`
    
    in your `Podfile` which would bring in  `PWLocation` and `PWCoreNoAds` automatically.

## Documentation

Framework documentation is included in the the repository's `Documents` folder in both HTML and Docset formats. You can also find the [latest documentation online](http://phunware.github.io/maas-mapping-ios-sdk/).


## Usage

The primary use of the components of PWMapKit revolve around creating a map view, displaying points of interest, showing the user's location and indoor routing.

### Setup

Make sure your app is correctly [set up](https://github.com/phunware/maas-core-ios-sdk#application-setup) before you start working on map integration.

## Location Permissions

Location authorization of "When In Use" or "Always" is required for a PWLocationManager to function normally. Please follow [Apple's Best Practices](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services) for requesting location permissions. Do not attempt to use a PWLocationManager if the user does not provide location authorization as this can lead to unexpected behavior.

### Adding Map View

```objc
// Load a building.
[PWBuilding buildingWithIdentifier:<#buildingID#> completion:^(PWBuilding *building, NSError *error) {
	// Get the buliding object here
	<#building#>					
}];

...

// Show the building on the map
PWMapView *map = [[PWMapView alloc] initWithFrame:<#frame#>];
map.delegate = self;
[self.view addSubview:map];

[mapView setBuilding:<#building#> animated:<#animated#> onCompletion:(void (^)(NSError *error))completion]
```


### Register Location Provider

The PWMapView can display a user location on the map if a location provider is registered with the PWMapView. The location providers are in the PWLocation framework, and each different provider requires different steps to set up (see readme here https://github.com/phunware/maas-location-ios-sdk to view setup examples of all different provider options). Once the location provider is initialized, the following call may be used to register the provider with the PWMapView:

```objc
[mapView registerLocationManager:<managerObject>];
```

NOTE: If using a virtual beacon provider such as Mist or Beacon Point, the "Uses Bluetooth LE accessories" background mode must be enabled in the "Capabilities" tab of your project's settings.

### Routing

```
PWRouteOptions* options = [[PWRouteOptions alloc] initWithAccessibilityEnabled:false
                                                              landmarksEnabled:false
                                                      excludedPointIdentifiers:nil];

[PWRoute createRouteFrom:startPoint to:endPoint options:options completion:^(PWRoute *route, NSError *error) {
	// Plot the route on the map
	[mapView navigateWithRoute:route];            
}];
```

## Attribution

PWMapKit uses the following third-party components. All components are prefixed with `PW` to avoid namespace collisions should your application also use an included component.

| Component | Description | License |
|:---------:|:-----------:|:-------:|
|[SVPulsingAnnotationView](https://github.com/samvermette/SVPulsingAnnotationView)|A customizable MKUserLocationView replica for your iOS app.|[MIT](https://github.com/samvermette/SVPulsingAnnotationView/blob/master/LICENSE.txt)|

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
