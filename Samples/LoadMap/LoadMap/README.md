LoadMap Sample for iOS
====================

### Usage

The primary use of the components for this sample revolve around creating a map view to show the building on the map

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