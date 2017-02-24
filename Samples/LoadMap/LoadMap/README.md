LoadMap Sample for iOS
====================

### Usage

The primary use of the components for this sample revolve around creating a map view to show the building on the map

### Configuration

1. Go to the `Samples/LoadMap` directory with `Terminal` in this project, then run `pod install`.
2. The `LoadMap.xcworkspace` should be gernated if the previous step is done successfully. Open the xcworkspace in Xcode.
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

### Adding Map View

### ViewController.m

```objc
// Load a building
[PWBuilding buildingWithIdentifier:<#buildingID#> completion:^(PWBuilding *building, NSError *error) {
	// Get the buliding object here
	<#building#>					
}];
                    
...

// Show the building on the map
PWMapView *map = [[PWMapView alloc] initWithFrame:<#frame#>];
map.delegate = self;
[self.view addSubview:map];

[mapView setBuilding:<#building#>];