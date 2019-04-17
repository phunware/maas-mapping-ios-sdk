## Sample - Walk Time

### Overview
- Display walk time at the bottom of map.

### Usage

- This feature is supposed to be combined with [turn by turn](./TurnByTurn.md), so just need to fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, `startPOIIdentifier` and `destinationPOIIdentifier` in TurnByTurnCollectionViewController.swift.

### Sample Code
- [WalkTimeViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/WalkTime/WalkTimeViewController.swift)
- [WalkTimeView.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/WalkTime/Views/WalkTimeView.swift)
- [WalkTimeView.xib](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/WalkTime/Views/WalkTimeView.xib)

**Step 1: add [turn by turn](./TurnByTurn.md) first**

**Step 2: Copy the following files to your project**

- WalkTimeView.swift
- WalkTimeView.xib

**Step 3: Override `initializeTurnByTurn()` to ensure `configureWalkTimeView()` is called at the same time**

```
override func initializeTurnByTurn() {
	super.initializeTurnByTurn()

	// Show walk time view when turn by turn is visible
	configureWalkTimeView()
}
```

**Step 4: Add the following methods to your view controller**

```
func configureWalkTimeView() {
    if let walkTimeView = Bundle.main.loadNibNamed(String(describing: WalkTimeView.self), owner: nil, options: nil)?.first as? WalkTimeView {
        view.addSubview(walkTimeView)

        // Layout
        walkTimeView.translatesAutoresizingMaskIntoConstraints = false
        walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        walkTimeView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        walkTimeView.isHidden = true

        self.walkTimeView = walkTimeView

        updateWalkTimeView()
    }
}

func updateWalkTimeView() {
    // Update every 5 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
        self?.updateWalkTimeView()
    }

    let distance = remainingDistance()
    guard let walkTimeView = walkTimeView, distance >= 0 else {
        return
    }

    // Remove it when it's approaching the destination
    if distance < 5, let currentInstruction = mapView.currentRouteInstruction(), let lastInstruction = mapView.currentRoute.routeInstructions.last, currentInstruction == lastInstruction {
        walkTimeView.removeFromSuperview()
        return
    }

    // Set initial value
    walkTimeView.updateWalkTime(distance: distance, averageSpeed: averageSpeed)

    NotificationCenter.default.post(name: .WalkTimeChanged, object: nil, userInfo: [NotificationUserInfoKeys.remainingDistance : distance, NotificationUserInfoKeys.averageSpeed : averageSpeed])
}

func remainingDistance() -> CLLocationDistance {
    // Recalculate only when the blue dot is snapping on the route path
    guard let lastUpdateLocation = lastUpdateLocation, snappingLocation == true, let currentInstruction = self.mapView.currentRouteInstruction(), let instructions = self.mapView.currentRoute.routeInstructions, let currentIndex = instructions.firstIndex(of: currentInstruction) else {
        return -1
    }

    var distance: CLLocationDistance = 0

    // The distance for the remaining instructions
    let remainingInstructions = instructions[(currentIndex+1)...]
    for instruction in remainingInstructions {
        distance += instruction.distance
    }

    // The distance from current location to the end of current instruction
    if let instructionEndLocation = currentInstruction.points.last?.coordinate {
        let userLocation = CLLocation(latitude: lastUpdateLocation.coordinate.latitude, longitude: lastUpdateLocation.coordinate.longitude)
        let endLocation = CLLocation(latitude: instructionEndLocation.latitude, longitude: instructionEndLocation.longitude)
        distance += userLocation.distance(from: endLocation)
    }

    return distance
}
```

As well as the extension methods

```
// MARK: - PWMapViewDelegate

extension WalkTimeViewController: PWMapViewDelegate {

    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        lastUpdateLocation = userLocation
    }

    func mapViewStartedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = true
    }

    func mapViewStoppedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = false
    }

    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        // Update walk time when blue dot is not acquired
        if lastUpdateLocation == nil, let currentIndex = self.mapView.currentRoute.routeInstructions.firstIndex(of: instruction), let remainingInstructions = self.mapView.currentRoute.routeInstructions?[currentIndex...] {
            var distance: Double = 0
            for instruction in remainingInstructions {
                distance += instruction.distance
            }
            self.walkTimeView?.updateWalkTime(distance: distance, averageSpeed: 0)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WalkTimeViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            clLocationManager.startUpdatingLocation()
            // Re-register location manager
            mapView.unregisterLocationManager()
            let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
            DispatchQueue.main.async { [weak self] in
                self?.mapView.register(managedLocationManager)
            }
        default:
            print("Not authorized to start PWManagedLocationManager")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            speedArray.append(location.speed)
            while speedArray.count > 5 {
                speedArray.remove(at: 0)
            }
        }
    }
}
```

# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
