PWMapKit SDK for iOS
====================

> Version 2.6.0

**PWMapKit** is a comprehensive indoor mapping and wayfinding SDK that allows easy integration with Phunware's indoor maps and location-based services.  Visit http://maas.phunware.com/ for more details and to sign up.


## Requirements

- PWCore v2.0.0 or greater
- iOS 7.0 or greater
- Xcode 6 or greater


## Installation

`PWMapKit` has a dependency on the [`PWCore`](https://github.com/phunware/maas-core-ios-sdk) and [`PWLocation`](https://github.com/phunware/maas-location-ios-sdk) frameworks.

Phunware recommends using [CocoaPods](http://www.cocoapods.org) to integrate the framework.  Simply add `pod 'PWMapKit'` to your podfile.

Alternatively, all of the following frameworks can be added to the Vendor/Phunware directory of your project:

- PWMapKit.framework
- PWCore.framework
- PWLocation.framework


## Documentation

Framework documentation is included in the the repository's `Documents` folder in both HTML and Docset formats. You can also find the [latest documentation online](http://phunware.github.io/maas-mapping-ios-sdk/).


## Sample Applications

The framework comes with a ready-to-use sample applications. In order to use this application you will need to update the configuration with your MaaS credentials and location provider information.

1. Navigate ot the sample application directory and run `pod install` from the command line.
2. Update your MaaS credentials and set up the building identifier in `PWMapKitSampleInfo.plist`.
3. Update the location provider initializers in `PWViewController.m`.


## Usage

The primary use of the components of PWMapKit revolve around creating a map view, displaying points of interest, showing the user's location and indoor routing.


### Adding Indoor Maps to a Map View

```objc
PWMapView *map = [[PWMapView alloc] initWithFrame:<#frame#>
                                       buildingID:<#buildingID#>];
map.delegate = self;
[self.view addSubview:map];

...

// Load a different building.
[mapView loadBuilding:<#buildingID#>];
```


### Indoor Location

The associated PWLocation framework implements an abstract indoor location manager protocol very similar to `CLLocationManager` which can be used to provide indoor location monitoring. PWSLLocationManager implements this protocol to provide BLE-based indoor location information using SenionLab beacons.

```objc
PWSLLocationManager *locationManager =
[[PWSLLocationManager alloc] initWithMapIdentifier:<#map-UUID#>
                                customerIdentifier:<#customer-UUID#>];
[locationManager setFloorIDMapping:<#mapping#>];
[map registerIndoorLocationManager:locationManager];
map.showsIndoorUserLocation = YES;
```


### Routing

The indoor routing APIs have been redesigned for simplicity.


#### Routing Between Points of Interest and Indoor Locations

See [this article](https://developer.phunware.com/display/DD/Calculating+Directions) for how to perform indoor routing with the PWMapKit SDK.


## Attribution

PWMapKit uses the following third-party components. All components are prefixed with `PW` to avoid namespace collisions should your application also use an included component.

| Component | Description | License |
|:---------:|:-----------:|:-------:|
|[SVPulsingAnnotationView](https://github.com/samvermette/SVPulsingAnnotationView)|A customizable MKUserLocationView replica for your iOS app.|[MIT](https://github.com/samvermette/SVPulsingAnnotationView/blob/master/LICENSE.txt)|
