PWMapKit SDK for iOS
==================

Version 2.3.0 BETA (Use PWMapKit v2.2.0 for production)

PWMapKit is a comprehensive indoor mapping and wayfinding SDK that allows easy integration with Phunware's indoor maps and Location Based Services (LBS). Visit http://maas.phunware.com/ for more details and to sign up.



Requirements
------------

- MaaS Core v1.3.0 or greater
- iOS 7.0 or greater
- Xcode 6 or greater



Installation
------------

PWMapKit has a dependency on MaaSCore.framework, which is available here: https://github.com/phunware/maas-core-ios-sdk and PWLocation.framework, which is available here: https://github.com/phunware/maas-location-ios-sdk

It's recommended that you add the MaaS frameworks to the Vendor/Phunware directory, then, add the MaaSCore.framework and PWMapKit.framework to your Xcode project.

The following frameworks are required:
````
MaaSCore.framework
PWLocation.framework
````

Alternatively you can install PWMapKit using [CocoaPods](http://www.cocoapods.org):
````
// Add this to your Podfile
pod PWMapKit
````

Scroll down for implementation details.



Documentation
------------

PWMapKit documentation is included in the the repository's Documents folder as both HTML and as a .docset. You can also find the latest documentation here: http://phunware.github.io/maas-mapping-ios-sdk/



Sample Application
------------

PWMapKit comes with a sample application ready to use. However, you will need to update the application with your MaaS credentials and location provider information.

1. Update your MaaS credentials and setup the building identifier in `PWMapKitSampleInfo.plist`.
2. Update the localtion provider initializers in `PWViewController.m`



Integration
-----------

The primary methods and objects in PWMapKit revolve around creating a map view, displaying annotations, displaying a user's location and navigation.

### Adding Indoor Maps to a Map View

````objective-c
	// Replace all referencs of MKMapView with PWMapView
    PWMapView *mapView = [[PWMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    // Load a building
    [mapView loadBuilding:BUILDING_ID];
    
    // That's it!
````


### Indoor Location

PWMapKit implements an abstract indoor location manager protocol very similar to CLLocationManager, which can be implemented to provide indoor location. PWMSELocationManager implements this protocol to provide Wi-Fi based indoor location information.

````objective-c
	CLLocationCoordinate2D here;
    PWMSELocationManager *locationManager = [[PWMSELocationManager alloc] initWithVenueGUID:@"VENUE GUID" location:here];
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
````


### Routing

The indoor routing APIs have been structured to mirror MKMapKit's routing methods. The three main routing classes are PWDirectionsRequest, PWDirections and PWDirectionsResponse. Please see the API documentation and examples below for additional detail.



#### Routing Between Points of Interest

````objective-c
	// To fetch a route between two points of interest, you would call the following method:
    id<PWAnnotation> start, end;
    
    PWDirectionsRequest *request = [[PWDirectionsRequest alloc] initWithSource:start
                                                                   destination:end
                                                                          type:PWDirectionsTypeAny];
    
    PWDirections *directions = [[PWDirections alloc] initWithRequest:request];
    
    __weak __typeof(self)weakSelf = self;
    
    [directions calculateDirectionsWithCompletionHandler:^(PWDirectionsResponse *response, NSError *error) {
        if (!error)
        {
            [weakSelf.mapView plotRoute:response.routes.firstObject];
        }
    }];
    
    // Once you're done with the route, you can remove it from the map:
    [mapView cancelRouting];
````



#### Routing from a Location to a Point of Interest

````objective-c
	// To fetch a route between two points of interest, you would call the following method:
    id<PWAnnotation> end;
    id <PWLocation> location;
    
    PWDirectionsRequest *request = [[PWDirectionsRequest alloc] initWithLocation:location
                                                                     destination:end
                                                                            type:PWDirectionsTypeAny];
    
    PWDirections *directions = [[PWDirections alloc] initWithRequest:request];
    
    __weak __typeof(self)weakSelf = self;
    
    [directions calculateDirectionsWithCompletionHandler:^(PWDirectionsResponse *response, NSError *error) {
        if (!error)
        {
            [weakSelf.mapView plotRoute:response.routes.firstObject];
        }
    }];
    
    // Once you're done with the route, you can remove it from the map:
    [mapView cancelRouting];
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
    <td><a href="https://github.com/samvermette/SVPulsingAnnotationView">SVPulsingAnnotationView</a></td>
    <td>
     A customizable MKUserLocationView replica for your iOS app.
    </td>
    <td style="text-align:center;""><a href="https://github.com/samvermette/SVPulsingAnnotationView/blob/master/LICENSE.txt">MIT</a>
    </td>
  </tr>
</table>
