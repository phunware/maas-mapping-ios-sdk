PWMapKit Samples - Location Sharing
====================

**LocationSharing** is a sample app which shares your location and displays other shared locations on a map


## Requirements

- PWMapKit 3.3.0 or greater
- iOS 9.0 or greater
- Xcode 8 or greater


## Installation

* Phunware recommends using [CocoaPods](http://www.cocoapods.org) to integrate the framework. As the `Podfile` is ready, just go to this directory to execute the following command in Terminal:

	'pod update'

* After pod update is done, the 'LocationSharing.xcworkspace' should be created in the directory


## Configuration

* Open 'LocationSharing.xcworkspace' and select 'AppDelegate.m', then put your own credential which you can get from app list page in Phunware MaaS Portal https://maas.phunware.com/n/account/apps

![](https://lbs-prod.s3.amazonaws.com/sdk/files/step-to-get-app-credential.png)

	applicationId - The App ID
	accessKey - The Access Key
	signatureKey - The Signature Key

* Then select 'ViewController.swift', put a building ID for 'buildingIdentifier', which you can get from building edit page in Phunware MaaS Portal

![](https://lbs-prod.s3.amazonaws.com/sdk/files/step-to-get-app-buildingID.png)


## Location Sharing Setup

By default when you share your location, you will be sending an empty display name and user type. Use the following to change:

```
mapView.sharedLocationDisplayName = <Display Name>
mapView.sharedLocationUserType = <User Type>
```

In order to get the list of shared locations in your building and on your floor you need to conform to the PWLocationSharingDelegate

```
ViewController: PWLocationSharingDelegate
...

mapView.locationSharingDelegate = self
```


## Starting and Stopping Location Sharing

To start sharing the current device's location, call startSharingUserLocation on the mapView object after the building has loaded.
```
mapView.startSharingUserLocation()
```

To start retrieving shared locations, call startRetrievingSharedLocations on the mapView object after the building has loaded.
```
mapView.startRetrievingSharedLocations()
```
*Sharing location and retrieving locations are independent events. You can use one without the other.*

To stop sharing the current device's location, call stopSharingUserLocation on the mapView object.
```
mapView.stopSharingUserLocation()
```

To stop retrieving shared locations, call stopRetrievingSharedLocations on the mapView object.
```
mapView.stopRetrievingSharedLocations()
```


## Location Sharing Delegate

didUpdate is called when the shared locations have been updated. It provides a complete up to date list of all shared locations per building and floor.

```
func didUpdate(_ sharedLocations: Set<PWSharedLocation>!)
```

(Optional)
didAdd is called when shared locations have been added. Any time a shared locations are added this will be fired.
```
func didAdd(_ addedSharedLocations: Set<PWSharedLocation>!)
```

(Optional)
didRemove is called when shared locations have been removed. Any time shared locations are removed this will be fired.
```
func didRemove(_ removedSharedLocations: Set<PWSharedLocation>!)
```


## PWSharedLocation
```
// The building identifier.
var buildingId: NSNumber! { get }

// The floor identifier.
var floorId: NSNumber! { get }

// The device identifier.
var deviceId: String! { get }

// The source of where the shared location is coming from.
var source: String! { get }

// The display name of the shared location.
var displayName: String! { get }

// The current location of the shared location.
var location: CLLocationCoordinate2D { get }

// The user type of the shared location.
open var userType: String! { get }
```

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
