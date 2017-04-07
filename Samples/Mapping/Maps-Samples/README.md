Mapping Sample for iOS
====================

### Usage

The primary use of the Mapping sample demonstrates creating a map view to show the building with points of interest and allowing users to route from current location to a specific point. This sample is also fully accessible allowing for VoiceOver routing.

### Configuration

1. Go to the `Samples/Mapping` directory with `Terminal` in this project, then run `pod install`.
2. The `Maps-Samples.xcworkspace` should be gernated if the previous step is done successfully. Open the xcworkspace in Xcode.
3. Open the `SampleConfiguration-Map.plist` file in Xcode and plug your Maas organization values into the corresponding fields below:

```
appId
accessKey
signatureKey

buildings ->
identifier
name
```
 For BLE such as Senion:

 ```
BLE ->
mapIdentifier
customerIdentifier
```
For VBLE such as Beacon Point or Mist:

```
VBLE ->
sdkToken
```

When fetching the building in MapViewController.m make sure to comment/uncomment the corresponding BLE or VBLE code depending on your configuration.

```objc
[PWBuilding buildingWithIdentifier:_buildingId completion:^(PWBuilding *building, NSError *error) {
   ...
        dispatch_async(dispatch_get_main_queue(), ^{
            // For virtual beacon change to use VBLE key
            NSDictionary *bleConf = weakself.configuration[@"BLE"];
            // NSDictionary *vbleConf = weakself.configuration[@"VBLE"];
            PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:weakself.buildingId];
            
            // For virtual beacon uncomment virtualBeaconToken and remove senionCustomerID, senionMapID
            managedLocationManager.senionCustomerID = bleConf[@"customerIdentifier"];
            managedLocationManager.senionMapID = bleConf[@"mapIdentifier"];
            // managedLocationManager.virtualBeaconToken = vbleConf[@"sdkToken"];
            [weakself.mapView registerLocationManager:managedLocationManager];
        });
   ...
}];
```

### Adding Map View

### MapViewController.m

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
```

### Search for points of interest

### DirectoryController.m

```objc
[<#floor#> pointsOfInterestOfType:<#pointOfInterestType#> containing:<#searchTerm#>]
```

### Routing between two POIs

### MapViewController.m

```objc
// Initializing a route
 [PWRoute initRouteFrom:<#startPoint#> to:<#endPoint#> accessibility:accessibility completion:^(PWRoute *route, NSError *error) {

}];

 ...

 // Displaying a route on the map
 PWMapView *map = [[PWMapView alloc] initWithFrame:<#frame#>];
 [self.map navigateWithRoute:<#route#>];
 ```

 ### Custom Pin Annotation

 ### MapViewController.m

```objc
MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
annotation.coordinate = CLLocationCoordinate2DMake(30.359648, -97.742567);
annotation.title = @"A Custom Annotation";
annotation.subtitle = @"A Custom Annotation";
[self.mapView addAnnotation:annotation];
```
