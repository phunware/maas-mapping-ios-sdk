PWMapKit Samples for iOS
====================

## LoadMap

### Usage

The primary use of the components for this sample revolve around creating a map view to show the building on the map

### Adding Map View

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

## Mapping

### Usage

The primary use of the Mapping sample include creating a map view to show the building with points of interest allowing users to route from current location to a specific point. This sample is also fully accessible allowing for voice over routing.

### Routing between two POIs

```objc
// Initiating a route
 [PWRoute initRouteFrom:<#startPoint#> to:<#endPoint#> accessibility:accessibility completion:^(PWRoute *route, NSError *error) {}

 // Displaying a route on the map
 PWMapView *map = [[PWMapView alloc] initWithFrame:<#frame#>];
 [self.map navigateWithRoute:<#route#>];
