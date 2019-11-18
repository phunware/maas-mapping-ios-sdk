## Sample - Off Route
====================

### Overview
- This feature will monitor the users location updates alert the user if they deviated from the route using a predetermined distance and time threshold.

### Usage

- Need to fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, and `destinationPOIIdentifier` in OffRouteViewController.swift.

### Sample Code
- [OffRouteViewController.swift](./MapScenarios/Scenarios/OffRoute/OffRouteViewController.swift)
- [OffRouteModalViewController.swift](./MapScenarios/Scenarios/OffRoute/OffRouteModalViewController.swift)
- [OffRouteModalView.xib](./MapScenarios/Scenarios/OffRoute/OffRouteModalView.xib)

**Step 1: Copy the following files to your project**

- OffRouteViewController.swift
- OffRouteModalViewController.swift
- OffRouteModalView.xib

**Step 2: In OffRouteViewController, pay attention to the `mapView(_:locationManager:didUpdateIndoorUserLocation:) delgate callback`**

```
func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
    if !firstLocationAcquired {
        firstLocationAcquired = true
        mapView.trackingMode = .follow

        self.buildRoute()
    } else {
        if !modalVisible, !dontShowAgain, !isOffRouteAlertCooldownActive {
            if let closestRouteInstruction = self.currentRoute?.closestInstructionTo(userLocation) {
                let distanceToRouteInstruction = MKMapPoint(userLocation.coordinate).distanceTo(closestRouteInstruction.polyline)
                
                if distanceToRouteInstruction > 0.0 {
                    if (distanceToRouteInstruction >= offRouteDistanceThreshold) {
                        offRouteTimer?.invalidate()
                        showOffRouteMessage()
                    } else if offRouteTimer == nil {
                        offRouteTimer = Timer.scheduledTimer(timeInterval: offRouteTimeThreshold,
                                                             target: self,
                                                             selector: #selector(offRouteTimerExpired),
                                                             userInfo: nil,
                                                             repeats: false)

                    }
                } else {
                    offRouteTimer?.invalidate()
                    offRouteTimer = nil
                }
            }
        }
    }
}
```

First calculate the distance from the current location to the closest point on the route. If that distance is greater than `offRouteDistanceThreshold`, call `showOffRouteMessage()` to show an alert. Otherwise, if we're only slightly off the route, but not past the `offRouteDistanceThreshold`, start a timer. If the time expires and we have not snapped back to the route, we'll call `showOffRouteMessage()` to display an alert.
```
@objc func offRouteTimerExpired() {
    offRouteTimer?.invalidate()
    offRouteTimer = nil
    showOffRouteMessage()
}
```


To avoid spamming users with the off route alert, we implement a "cooldown" interval after the user dismisses the off route alert. 
```
func offRouteAlert(_ alert: OffRouteModalViewController, dismissedWithResult result: OffRouteModalViewController.Result) {
    lastTimeOffRouteMessageWasDismissed = Date()
    modalVisible = false
    
    ... etc
}
```

The alert will not be displayed again until this interval expires.
```
private var isOffRouteAlertCooldownActive: Bool {
    guard let lastTime = lastTimeOffRouteMessageWasDismissed else {
        return false
    }
    
    return Date().timeIntervalSince(lastTime) < offRouteMessageCooldownInterval
}
```

# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
