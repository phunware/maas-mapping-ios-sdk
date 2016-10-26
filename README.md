PWMapKit SDK for iOS
====================

> Version 3.0.2

**PWMapKit** is a comprehensive indoor mapping and wayfinding SDK that allows easy integration with Phunware's indoor maps and location-based services.  Visit http://maas.phunware.com/ for more details and to sign up.


## Requirements

- PWLocation v3.0.0 or greater (Automatically include when pod install PWMapKit)
- PWCore v3.0.2 or greater (Automatically include when pod install PWMapKit)
- iOS 8.0 or greater
- Xcode 8 or greater


## Installation

* Phunware recommends using [CocoaPods](http://www.cocoapods.org) to integrate the framework. Simply add
 
	`pod 'PWMapKit'` 

	to your podfile, then the dependencies of `PWCore` and `PWLocation` are automatically added.

* Then add navigation icons the `Framework/MNW_Images.xcassets` to your project.


## Documentation

Framework documentation is included in the the repository's `Documents` folder in both HTML and Docset formats. You can also find the [latest documentation online](http://phunware.github.io/maas-mapping-ios-sdk/).


## Usage

The primary use of the components of PWMapKit revolve around creating a map view, displaying points of interest, showing the user's location and indoor routing.


### Adding Map View

```objc
// Load a building.
[PWBuilding buildingWithIdentifier:<#buildingID#> usingCache:<#cached#> completion:^(PWBuilding *building, NSError *error) {
	// Get the buliding object here
	<#building#>					
}];
                    
...

// Show the building on the map
PWMapView *map = [[PWMapView alloc] initWithFrame:<#frame#>];
map.delegate = self;
[self.view addSubview:map];

[mapView setBuilding:<#building#>];
```


### Set Indoor Location Manager

```objc
[mapView setMapViewLocationType:<#locationType#> configuration:<#configuration#>];
```

### Routing

```
PWRoute initRouteFrom:<#startPoint#> to:<#endPoint#> accessibility:<#accessibility#> completion:^(PWRoute *route, NSError *error) {
	// Plot the route on the map
	[mapView navigateWithRoute:route];            
}];
```

## Usage With Light Weight UI

The SDK provides a couple of UI view controllers, make it easier to integrate. You can directly add them to your app or extend to customization.


### PWMapViewController.h
Displaying a map for specified building.

```
// UI view controller initialization
PWMapViewController *mapViewController = [[PWMapViewController alloc] initWithBuilding:<#building#>];

// Present
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
[self presentViewController: navigationController animated:YES completion:^{
	// Set center of map 
	[mapViewController setCenterCoordinate:building.coordinate zoomLevel:19 animated:NO];
	// Set indoor location manager                                   
	[mapViewController.mapView setMapViewLocationType:<#locationType#> configuration:<#configuration#>];
}];
```

### PWBuildingViewController.h
Build POI selecting UI, and use the delegation to handle the POI that user selected.

```
// UI view controller initialization
PWBuildingViewController *buildingViewController = [[PWBuildingViewController alloc] initWithBuilding:<#building#>];

// Set the delegate the handle the route result.
routeViewController.delegate = <#PWBuildingViewControllerDelegate#>;

// Present
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:buildingViewController];
[self presentViewController: navigationController animated:YES completion:^{
}];
```


### PWRouteViewController.h
Build route POIs selection UI, and use the delegation to handle start/end POIs that user want to start a navigation.

```
// UI view controller initialization
PWRouteViewController *routeViewController = [[PWRouteViewController alloc] initWithBuilding:<#building#>];

// Set the delegate the handle the route result.
routeViewController.delegate = <#PWRouteInstructionViewDelegate#>;

// Present
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:routeViewController];
[self presentViewController:navigationController animated:YES completion:^{
}];
```

### PWRouteInstructionsViewController.h
Build route instrucation list UI, and use the delegation to handle the instruction that user selected.

```
// UI view controller initialization
PWRouteInstructionsViewController *routeInstructionsViewController = [[PWRouteInstructionsViewController alloc] initWithRoute:<#route#>];

// Set the delegate the handle the route result.
routeViewController.delegate = <#PWRouteInstructionsViewControllerDelegate#>;

// Present
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:routeInstructionsViewController];
[self presentViewController:navigationController animated:YES completion:^{
}];
```


## Sample Application

1. Go to the `Samples/LoadMap` directory with `Terminal` in this project, then run `pod install`.
2. The `LoadMap.xcworkspace` should be gernated if the previous step is done successfully, then open it in Xcode.
3. Open the `AppDelegate.m` file in Xcode and put the right value for the constants below:

````
#define kAppID @"<App Identifier>"
#define kAccessKey @"<Access Key>"
#define kSignatureKey @"<Signature Key>"
#define kEncryptionKey @"<Encrytion Key>"
````
Optional, open `ViewController.m` to replace the `buildingID` of `20234` and put the right value for the constants below:

````
#define kBLECustomerIdentifier @"<Senion Customer Identifier>"
#define kBLEMapIdentifier @"<Senion Map Identifier>"
...
````


## Attribution

PWMapKit uses the following third-party components. All components are prefixed with `PW` to avoid namespace collisions should your application also use an included component.

| Component | Description | License |
|:---------:|:-----------:|:-------:|
|[SVPulsingAnnotationView](https://github.com/samvermette/SVPulsingAnnotationView)|A customizable MKUserLocationView replica for your iOS app.|[MIT](https://github.com/samvermette/SVPulsingAnnotationView/blob/master/LICENSE.txt)|
