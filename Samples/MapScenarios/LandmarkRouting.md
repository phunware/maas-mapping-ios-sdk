## Sample - Turn By Turn with Landmarks

This sample is configured almost the same as [TurnByTurnViewController.swift](./MapScenarios/Scenarios/TurnByTurnViewController.swift), except that it will utilize Landmark information in the route instructions, when available.

### Overview
- Display turn-by-turn route instruction card on top of map, taking advantage of POIs and Waypoints configured as Landmarks.
- Swipe turn-by-turn card to select a route instruction.

### Usage

- Fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, `startPOIIdentifier` and `destinationPOIIdentifier`.

### Sample Code 
- [TurnByTurnLandmarksViewController.swift](./MapScenarios/Scenarios/TurnByTurnLandmarksViewController.swift) - View controller
- [TurnByTurnCollectionView.swift](./MapScenarios/Shared/TurnByTurnCollectionView/TurnByTurnCollectionView.swift) - Instruction collection view
- [TurnByTurnInstructionCollectionViewCell.swift](./MapScenarios/Shared/TurnByTurnCollectionView/Cells/TurnByTurnInstructionCollectionViewCell.swift) - Instruction cell
- [TurnByTurnInstructionCollectionViewCell.xib](./MapScenarios/Shared/TurnByTurnCollectionView/Cells/TurnByTurnInstructionCollectionViewCell.xib) - Instruction cell
- [DirectionImages.xcassets](./MapScenarios/Shared/TurnByTurnCollectionView/Icons/DirectionImages.xcassets) - direction images

**Step 1: Copy the following files to your project**

- TurnByTurnCollectionView.swift
- TurnByTurnInstructionCollectionViewCell.swift 
- TurnByTurnInstructionCollectionViewCell.xib 
- DirectionImages.xcassets 

**Step 2: Present turn by turn view on the map whenever building and route are loaded, configuring the route to enable Landmarks**

```
func startRoute() {
    // Set tracking mode to follow me
    mapView.trackingMode = .follow
    
    // Find the destination POI
    guard let startPOI = mapView.building.pois.first(where: { $0.identifier == startPOIIdentifier }),
        let destinationPOI = mapView.building.pois.first(where: { $0.identifier == destinationPOIIdentifier }) else {
        warning("Please put valid data for `startPOIIdentifier` and `destinationPOIIdentifier` in RoutingViewController.swift")
        return
    }
    
    // Create a PWRouteOptions object with landmarksEnabled set to true so landmarks will be injected into route info (if available)
    let routeOptions = PWRouteOptions(accessibilityEnabled: false,
                                      landmarksEnabled: true,
                                      excludedPointIdentifiers: nil)
    
    // Calculate a route and plot on the map with our specified route options
    PWRoute.createRoute(from: startPOI,
                        to: destinationPOI,
                        options: routeOptions,
                        completion: { [weak self] (route, error) in
        guard let route = route else {
            self?.warning("Couldn't find a route between POI(\(self?.startPOIIdentifier ?? 0)) and POI(\(self?.destinationPOIIdentifier ?? 0)).")
            return
        }
        
        // Plot route on the map
        let uiOptions = PWRouteUIOptions()
        self?.mapView.navigate(with: route, options: uiOptions)
        
        // Initial route instructions
        self?.initializeTurnByTurn()
    })
}

func initializeTurnByTurn() {
    mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
    
    if turnByTurnCollectionView == nil {
        turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
        turnByTurnCollectionView?.turnByTurnDelegate = self
        turnByTurnCollectionView?.configureInView(view)
    }
```

Because the view controller is a delegate of the `TurnByTurnCollectionView`, the collection view will ask the view controller for an `InstructionViewModel` to display for each instruction. The instruction view model is responsible for generating the turn by turn text that we display. Here, we use the `LandmarkInstructionViewModel` to calculate this from the current instruction, which will take any available landmarks into account:
```
func turnByTurnCollectionView(_ collectionView: TurnByTurnCollectionView, viewModelFor routeInstruction: PWRouteInstruction) -> InstructionViewModel {
    return LandmarkInstructionViewModel(for: routeInstruction)
}
```

When the button to show the entire route list is displayed, show the route instruction list
```
func turnByTurnCollectionViewInstructionExpandTapped(_ collectionView: TurnByTurnCollectionView) {
    let routeInstructionViewController = RouteInstructionListViewController()
    routeInstructionViewController.delegate = self
    routeInstructionViewController.configure(route: mapView.currentRoute)
    routeInstructionViewController.presentFromViewController(self)
}
```

The view controller is also a delegate of the `RouteInstructionListCollectionView`, which also needs an `InstructionViewModel` to generate the instruction text, similarly to the `TurnByTurnCollectionView`. We'll use `LandmarkInstructionViewModel` for this as well:
```
func routeInstructionListViewController(_ viewController: RouteInstructionListViewController, viewModelFor routeInstruction: PWRouteInstruction)
    -> InstructionViewModel {
    return LandmarkInstructionViewModel(for: routeInstruction)
}
```

# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
