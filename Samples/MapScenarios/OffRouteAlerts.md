## Sample - Off Route
====================

### Overview
- This feature will monitor the users location updates alert the user if they deviated from the route using a predetermined distance and time threshold.

### Usage

- Need to fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, and `destinationPOIIdentifier` in OffRouteViewController.swift.

### Sample Code
- [OffRouteViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/OffRoute/OffRouteViewController.swift)
- [OffRouteModalViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/OffRoute/OffRouteModalViewController.swift)
- [OffRouteModalView.xib](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/OffRoute/OffRouteModalView.xib)

**Step 1: Copy the following files to your project**

- OffRouteModalViewController.swift
- OffRouteModalView.xib

**Step 2: Add the following variables and methods to your view controller**

```
//Class variables
var currentRoute: PWRoute?
// offRouteDistanceThreshold is the distance in meters away from the closest point on the route the user has to be to trigger the Off Route alert
let offRouteDistanceThreshold: CLLocationDistance = 10.0
// offRouteTimeThreshold is the time in seconds the user has to be off the route line to trigger the Off Route alert
let offRouteTimeThreshold: TimeInterval = 5.0
var offRouteTimer: Timer? = nil
var modalVisible = false
var dontShowAgain = false

//Methods
@objc func fireTimer() {
    offRouteTimer?.invalidate()
    offRouteTimer = nil
    showModal()
}

private func showModal() {
    if (!modalVisible) {
        modalVisible = true

        let offRouteModal = OffRouteModalViewController()
        offRouteModal.modalPresentationStyle = .overCurrentContext
        offRouteModal.modalTransitionStyle = .crossDissolve

        offRouteModal.dismissCompletion = {
            self.modalVisible = false
        }

        offRouteModal.rerouteCompletion = {
            self.modalVisible = false
            self.mapView.cancelRouting()
            self.currentRoute = nil
            //Add code to build new route
        }

        offRouteModal.dontShowAgainCompletion = {
            self.modalVisible = false
            self.dontShowAgain = true
        }

        present(offRouteModal, animated: true, completion: nil)
    }
}
```

As well as the extension methods

```
// MARK: - PWMapViewDelegate

extension OffRouteViewController: PWMapViewDelegate {

    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if (!modalVisible && !dontShowAgain) {
            if let closestRouteInstruction = self.currentRoute?.closestInstructionTo(userLocation) {
                let distanceToRouteInstruction = MKMapPoint(userLocation.coordinate).distanceTo(closestRouteInstruction.polyline)
                if (distanceToRouteInstruction > 0.0) {
                    if (distanceToRouteInstruction >= offRouteDistanceThreshold) {
                        offRouteTimer?.invalidate()
                        showModal()
                    } else {
                        if (offRouteTimer == nil) {
                            offRouteTimer = Timer.scheduledTimer(timeInterval: offRouteTimeThreshold, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
                        }
                    }
                } else {
                    if (offRouteTimer != nil) {
                        offRouteTimer?.invalidate()
                        offRouteTimer = nil
                    }
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension OffRouteViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                startManagedLocationManager()
            default:
                mapView.unregisterLocationManager()
                print("Not authorized to start PWLocationManager")
        }
    }
}
```

# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
