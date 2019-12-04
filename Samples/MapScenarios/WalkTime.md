## Sample - Walk Time

### Overview
- Display walk time at the bottom of map.

### Usage

- Need to fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, `startPOIIdentifier` and `destinationPOIIdentifier` in TurnByTurnCollectionViewController.swift.

### Sample Code
- [WalkTimeViewController.swift](./MapScenarios/Scenarios/WalkTimeViewController.swift)
- [WalkTimeView.swift](./MapScenarios/Shared/WalkTimeView/WalkTimeView.swift)
- [WalkTimeView.xib](./MapScenarios/Shared/WalkTimeView/WalkTimeView.xib)

**Step 1: Copy the following files to your project**

- WalkTimeViewController.swift
- WalkTimeView.swift
- WalkTimeView.xib

**Step 2: Pay attention to the `locationManager(_:didUpdateLocations:) delegate callback:**
This is called periodically by the location manager. We keep track of the previous speeds so we can average them out for walk time calculations.

```
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let lastLocation = locations.last else {
        return
    }
    
    speedSamples.append(lastLocation.speed)
    
    let maxSamples = 5
    let count = speedSamples.count
    
    if speedSamples.count > maxSamples {
        speedSamples.removeFirst(count - maxSamples)
    }
}
```

**Step 3: Update the walk time on each maneuver change by calling `updateWalkTime()`**

```
func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
    turnByTurnCollectionView?.scrollToInstruction(instruction)
    
    // cancel the timer
    cancelWalkTimeUpdateTimer()
    
    // update the walk time
    updateWalkTime()
    
    // restart the timer
    startWalkTimeUpdateTimer()
}
```

**Step 4: `updateWalkTime()` calculates the time and updates the view**

If a blue dot has been acquired, we calculate the time from the current blue dot position. Otherwise, we calculate from the beginning of the current maneuver. When we get close enough to our destination, we remove the walk time view.
```
func updateWalkTime() {
    // we need a valid instruction, the list of all instructions,
    // and the current instruction index before we can calculate anything
    guard let currentInstruction = mapView.currentRouteInstruction(),
        let allInstructions = mapView.currentRoute.routeInstructions,
        let currentInstructionIndex = allInstructions.firstIndex(of: currentInstruction) else {
            return
    }
    
    // Update blue dot walk time when snapping to route, and we have a valid user location, otherwise use static calculations.
    let distance: CLLocationDistance
    
    if snappingLocation, let lastUpdateLocation = lastUpdateLocation {
        distance = calculateBlueDotDistance(from: lastUpdateLocation,
                                            currentInstruction: currentInstruction,
                                            allInstructions: allInstructions,
                                            currentInstructionIndex: currentInstructionIndex)
        
        // When we're at the destination, we're done. Remove the walk time view
        if distance < minDistanceToDestination,
            let lastInstruction = mapView.currentRoute.routeInstructions.last,
            currentInstruction == lastInstruction {
            walkTimeView?.removeFromSuperview()
            return
        }
    } else {
        distance = calculateStaticDistance(currentInstruction: currentInstruction,
                                           allInstructions: allInstructions,
                                           currentInstructionIndex: currentInstructionIndex)
    }
    
    walkTimeView?.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
    routeListController?.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
}

```

# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
