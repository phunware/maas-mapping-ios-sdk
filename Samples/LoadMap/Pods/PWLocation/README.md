PWLocation SDK for iOS
================

>Version 3.1.1

This is Phunware's iOS SDK for the Location module. Visit http://maas.phunware.com/ for more details and to sign up.

Requirements
------------

- PWCore v3.0.3 or greater
- iOS 9.0 or greater
- Xcode 7 or greater

Installation
------------

The easiest way to use PWLocation is via CocoaPods. Simply add 

`pod PWLocation` 

to your `Podfile`, then the `PWCore` would be automatically included. 


The following frameworks are required:

````
CoreMotion.framework
CoreBluetooth.framework
libz.dylib
libxml2.2.dylib
libsqlite3.dylib
````


Documentation
------------

Documentation is included in the Documents folder in the repository as both HTML and as a .docset. You can also find the latest documentation here: http://phunware.github.io/maas-location-ios-sdk/



Integration
-----------

`PWLocation` is meant to be used in conjunction with PWMapKit but can be used as a standalone SDK.

## PWCore Setup

Some PWCore configuration is required to use any provider in PWLocation. In the MaaS portal, retrieve your application identifier, signature key, access key, and encryption key (if you have one). In your application's AppDelegate, add the following:

````objective-c
[PWCore setApplicationID:@"YOUR_APPLICATION_IDENTIFIER"
               accessKey:@"YOUR_ACCESS_KEY"
            signatureKey:@"YOUR_SIGNATURE_KEY"
           encryptionKey:@"YOUR_ENCRYPTION_KEY"]; // If you do not have an encryption key, just pass an empty string here i.e. @""
````

## PWMSELocationManager

The `PWMSELocationManager` class defines the interface for configuring the delivery of Cisco Mobility Services Engine (MSE) location-related events to your application. Use an instance of this class to establish the parameters that determine when location events should be delivered and to start and stop the actual delivery of those events. This class conforms to the `PWLocationManager` protocol.

````objective-c
// Initialization:
PWMSELocationManager *locationManager = [[PWMSELocationManager alloc] initWithVenueGUID:@"YOUR_MSE_VENUE_GUID"];
locationManager.delegate = self;

// Start fetching location updates:
[locationManager startUpdatingLocation];
````

## PWSLLocationManager

The `PWSLLocationManager` class defines the interface for configuring the delivery of BLE location-related events to your application. Use an instance of this class to establish the parameters that determine when location events should be delivered and to start and stop the actual delivery of those events. This class conforms to the `PWLocationManager` protocol.

````objective-c
// Initialization:
PWSLLocationManager *locationManager = [[PWSLLocationManager alloc] initWithMapIdentifier:@"YOUR_SENION_MAP_ID" customerIdentifier:@"YOUR_SENION_CUSTOMER_ID"];
locationManager.delegate = self;

// Start fetching location updates:
[locationManager startUpdatingLocation];
````

## PWManagedLocationManager

The `PWManagedLocationManager` class take a location update from one of the other providers listed here and uses an algorithm to improve the accuracy of that location before returning it to the consumer.

This manager relies on a building bundle that is created by the MaaS server. The building is configured in the MaaS portal, and the building identifier will be found in those portal configuration pages.

To create a `PWManagedLocationManager`, call its `initWithBuildingId:` function and pass it the desired building identifier. Next, set any private keys necessary for the chosen provider(s). Finally, call `startUpdatingLocation` on the `PWManagedLocationManager` object. The manager will fetch and parse the required server bundles and begin giving location updates as soon as possible.

````objective-c
// Initialize the manager:	
PWManagedLocationManager *manager = [[PWManagedLocationManager alloc] initWithBuildingId:<YOUR_BUILDING_IDENTIFIER>];

// Configure the internal provider(s):
// If using Senion
manager.senionCustomerID = @"YOUR_SENION_CUSTOMER_ID";
manager.senionMapID = @"YOUR_SENION_MAP_ID";
// If using virtual beacon
manager.virtualBeaconToken = @"YOUR_VIRTUAL_BEACON_SDK_TOKEN";

// Start fetching location updates:
[manager startUpdatingLocation];
````

NOTE: If using a virtual beacon provider such as Mist or Beacon Point with PWManagedLocationManager, the "Uses Bluetooth LE accessories" background mode must be enabled in the "Capabilities" tab of your project's settings.

## PWVBLocationManager

The `PWVBLocationManager` class is the parent class to both flavors of virtual beacon location managers: `PWBPLocationManager` (Beacon Point) and `PWMSLocationManager` (Mist). They are both created with similar functions which require an virtual beacon SDK Token, a floor configuration array, and a completion block.

The floor configurations array contains a configuration dictionary for each floor. The dictionaries contain a virtual beacon floor name `(NSString *)`, a matching MaaS floor identifier `(NSNumber *)`, an upper left coordinate dictionary, and a lower right coordinate dictionary. The upper left and lower right coordinate dictionaries contain latitude/longitude coordinates that match to the origin (0,0) of the virtual beacon map and the maximum (x,y) position of the virtual beacon map, respectively. Upper left matches to (0,0), and lower right matches to (max(x),max(y)). Example floor configuration dictionary:
````
{
    "id" : @"MIST_FLOOR_NAME",
    "maasId" : 195842,

    "upperLeft" : {
        "longitude" : -97.742525,
        "latitude" : 30.360108
    },
    "lowerRight" : {
        "longitude" : -97.741753,
        "latitude" : 30.359737
    }
}
````

````objective-c
// PWBPLocationManager - Beacon Point
// Initialize the manager:	
[PWBPLocationManager createBPWithSDKToken:@"YOUR_VIRTUAL_BEACON_SDK_TOKEN" floorConfigurations:<YOUR_VIRTUAL_BEACON_FLOOR_CONFIGURATIONS> onComplete:^(PWBPLocationManager *manager, NSError *error) {
    if (error != nil) {
	    // Error handling here
    } else {
        [manager startUpdatingLocation];
    }
}];

// PWMSLocationManager - Mist
// Initialize the manager:	
[PWBPLocationManager createMSWithSDKToken:@"YOUR_MIST_SDK_TOKEN" floorConfigurations:<YOUR_MIST_FLOOR_CONFIGURATIONS> onComplete:^(PWMSLocationManager *manager, NSError *error) {
    if (error != nil) {
	    // Error handling here
    } else {
        [manager startUpdatingLocation];
    }
}];
````

NOTE: If using a virtual beacon provider such as Mist or Beacon Point, the "Uses Bluetooth LE accessories" background mode must be enabled in the "Capabilities" tab of your project's settings.

## PWMockLocationManager

The `PWMockLocationManager` class allows you to implement a mock provider for testing and validation. This is extremely useful for location testing when you are not able to be on-site at a venue with a proper location provider. The mock location manager is initialized with a configuration object that is populated with JSON data.

It's important to note that the `floorIDMapping` property does not need to be specified for the `PWMockLocationManager`. The location floor IDs in the JSON should be equivalent to the building floor IDs.

````objective-c
// Initialize the configuration:	
NSURL *configurationURL = [NSURL URLWithString:@"YOUR_FILE_URL"];
NSData *data = [NSData dataWithContentsOfURL:configurationURL];
NSDictionary *configurationData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
PWMockLocationManagerConfiguration *configuration = [PWMockLocationManagerConfiguration unpack:configurationData];

// Initializing the location manager:
PWMockLocationManager *locationManager = [[PWMockLocationManager alloc] initWithMockLocationManagerWithConfiguration:configuration];
locationManager.delegate = self;

// Start fetching location updates:
[locationManager startUpdatingLocation];
````

## Location Updates

Location updates are returned via the delegate. Update events are very similar to `CLLocationManagerDelegate` events.

````objective-c
- (void)locationManager:(id<PWLocationManager>)manager didUpdateToLocation:(id<PWLocation>)location
{
    // Handle update.
}

- (void)locationManager:(id<PWLocationManager>)manager failedWithError:(NSError *)error
{
    // Handle failure.
}
````

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.