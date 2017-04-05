PWMapKit Samples - Custom Point of Interest
====================

**CustomPOI** is a sample app which shows how to create custom point of interest on the indoor mapping.


## Requirements

- PWLocation v3.1.0 or greater (Automatically include when pod install PWMapKit)
- PWCore v3.0.3 or greater (Automatically include when pod install PWMapKit)
- iOS 9.0 or greater
- Xcode 8 or greater


## Installation

* Phunware recommends using [CocoaPods](http://www.cocoapods.org) to integrate the framework. As the `Podfile` is ready, just go to this directory to execute the following command in Terminal:
 
	`pod update` 
	
* After pod update is done, the `CustomPOI.xcworkspace` should be created in the directory


## Configuration

* Open `CustomPOI.xcworkspace` and select `AppDelegate.m`, then put your own credential which you can get from app list page in Phunware MaaS Portal https://maas.phunware.com/n/account/apps

![](https://lbs-prod.s3.amazonaws.com/sdk/files/step-to-get-app-credential.png)
	
	kAppID - The App ID
	kAccessKey - The Access Key
	kSignatureKey - The Signature Key
	kEncryptionKey - leave it empty with ""
	
* Then select `ViewController.m`, put a building ID for `kBuildingIdentifier`, which you can get from building edit page in Phunware MaaS Portal 

![](https://lbs-prod.s3.amazonaws.com/sdk/files/step-to-get-app-buildingID.png)
	

## Create Custom Point of Interest

The `addCustomPointOfInterests` is to create and add a custom point of interest for the map.

* Create custom point of interest
	
	```
	// The (lat, long) for the custom point of interest
    CLLocationCoordinate2D poiLocation = CLLocationCoordinate2DMake(30.359931, -97.742507);
    
    // The floorId for the point of interest. It's only shown on the matched building floor, it's always shown if you set it to `0`.
    NSInteger poiFloorId = 207654;
    
    // The buildingId for the point of interest
    NSInteger poiBuildingId = kBuildingIdentifier;
    
    // The point of interest annotation title, it's optional.
    NSString *poiTitle = @"Custom POI";
    
    // The point of interest annotation image, it's optional.
    // If it's nil, SDK checks it `pointOfInterestType` property to use the type icon, and `pointOfInterestType` can be anyone of `building.pointOfInterestTypes`;
    // If `pointOfInterestType` property is still nil, SDK use the default icon at https://lbs-prod.s3.amazonaws.com/stock_assets/icons/0_higher.png
    UIImage *poiIcon = nil;
    
    PWCustomPointOfInterest *customPOI = [[PWCustomPointOfInterest alloc]
                 initWithCoordinate:poiLocation
                 floorId:poiFloorId
                 buildingId:poiBuildingId
                 title:poiTitle
                 image:poiIcon];
	```
	You also can specify if the text label is shown/hidden by `customPOI.showTextLabel = YES;`
* Add it to `PWMapView`

	```
	[self.mapView addAnnotation:customPOI];
	```
	
> IMPORTANT:
> 
> 1. The custom point of interest has to be added after the building is set.
> 
> 2. The custom point of interests are not included for route calculation, the SDK use the nearest point of interest for way finding.
> 3. The `PWCustomPointOfInterest` has to be initialized with valid `coordinate`, `floorId` and `buildingId`.
> 4. If you don't want to specify the icon image for the custom point of interest, you can use the generic icons provided by SDK by setting a POI type `customPOI.pointOfInterestType = ?` 
> 5. The supported POI type list can be get from `PWBuilding` object by `building.pointOfInterestTypes`



Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.