PWMapKit iOS SDK
==================

Version 1.0.0

This is the iOS SDK for Phunware's Mapping MaaS module. Visit http://maas.phunware.com/ for more details and to sign up.



Requirements
------------

- MaaSCore v1.2.0 or greater
- iOS 5.0 or greater
- Xcode 4.4 or greater



Installation
------------

PWMapKit has a dependency on MaaSCore.framework which is available here: https://github.com/phunware/maas-core-ios-sdk

It's recommended that you add the MaaS frameworks to the 'Vendor/Phunware' directory. Then add the MaaSCore.framework and PWMapKit.framework to your Xcode project.

The following frameworks are required:
````
MaaSCore.framework
````

Scroll down for implementation details.



Documentation
------------

PWMapKit documentation is included in the Documents folder in the repository as both HTML and as a .docset. You can also find the latest documentation here: http://phunware.github.io/maas-mapping-ios-sdk/


Overview
-----------

The MaaS Content Management SDK allows developers to fetch and manage the various pieces of data in the Content Management module, including containers, schemas, structure and content. Content Management spans across your entire organization, so different applications can potentially share the same content.

The PWMapKit framework object provides an embeddable indoor map interface. You can use this framewor to display indoor maps, annotate the map with custom points of interest, route between points, and more.


### Annotations

Annotations, or points of interest, allow you display information on the map view. You can fetch annotations from MaaS using the appropriate calls or add your own local annotations. It's important to note that navigation will only work with the annotations fetched from MaaS.

### Positioning

PWMapKit includes a variety of methods for positioning the map view. You can center on a specific point, center and zoom, and more.

### Location

If the user is on-site and has associated with the venue wi-fi network at least once they will be able to fetch their current location. The location is displayed as blue dot on the map view.

### Navigation

PWMapKit supports a variety of navigation methods. You can route between two points (annotations) or route from your current location to a specified point if location is enabled.


Integration
-----------

The primary methods and objects in PWMapKit revolve around creating a map view, displaying annotations, displaying the users location, and navigation.

### Creating A Map View

````objective-c
	// You must instantiate a PWMapView with the following method. The building ID and venue ID can be found in the MaaS Portal. It's important to set the delegate if you want to be notified of map view events.
    PWMapView *mapView = [[PWMapView alloc] initWithFrame:self.view.bounds buildingID:@"BUILDING_ID" venueID:@"VENUE_ID"];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
````

### Fetching annotations

````objective-c
	// To fetch annotations from MaaS you would call the following method
    __weak __typeof(&*self)weakSelf = self;
    
    [PWMapKit getMapAnnotationsForBuildingID:@"BUILDING_ID" completion:^(NSArray *mapAnnotations, NSError *error) {
    	 // Add annotations to the map view
        [weakSelf.mapView addAnnotations:mapAnnotations];
    }];
````

Attribution
-----------
PWMapKit uses the following third-party components. All components are prefixed so you don't have to worry about namespace collisions.

<table>
  <tr>
  <th style="text-align:center;">Component</th>
  <th style="text-align:center;">Description</th>
  <th style="text-align:center;">License</th>
  </tr>
  <tr>
    <td><a href="https://github.com/jessedc/JCTiledScrollView">JCTiledScrollView</a></td>
    <td>
     A set of classes that wrap UIScrollView and CATiledLayer. It aims to simplify displaying large images and PDFs at multiple zoom scales.
    </td>
    <td style="text-align:center;""><a href="https://github.com/jessedc/JCTiledScrollView/blob/master/LICENCE.txt">MIT</a>
    </td>
  </tr>
</table>
