## Sample - Turn By Turn 

### Overview
- Display turn-by-turn route instruction card on top of map.
- Swipe turn-by-turn card to select a route instruction.

### Usage

- Fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, `startPOIIdentifier` and `destinationPOIIdentifier`.

### Sample Code 
- [TurnByTurnViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/TurnByTurnViewController.swift) - View controller
- [TurnByTurnCollectionView.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/TurnByTurn/Collection%20View/TurnByTurnCollectionView.swift) - Instruction collection view
- [TurnByTurnInstructionCollectionViewCell.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/TurnByTurn/Collection%20View/Cells/TurnByTurnInstructionCollectionViewCell.swift) - Instruction cell
- [TurnByTurnInstructionCollectionViewCell.xib](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/TurnByTurn/Collection%20View/Cells/TurnByTurnInstructionCollectionViewCell.xib) - Instruction cell
- [DirectionImages.xcassets](https://github.com/phunware/maas-mapping-ios-sdk/tree/readme/Samples/MapScenarios/MapScenarios/Scenarios/TurnByTurn/Collection%20View/Icons/DirectionImages.xcassets) - direction images

**Step 1: Copy the following files to your project**

- TurnByTurnCollectionView.swift
- TurnByTurnInstructionCollectionViewCell.swift 
- TurnByTurnInstructionCollectionViewCell.xib 
- DirectionImages.xcassets 

**Step 2: Present turn by turn view on the map whenever the route is ready**

```
PWRoute.createRoute(from: startPOI, to: destinationPOI, accessibility: false, excludedPoints: nil, completion: { [weak self] (route, error) in
	guard let route = route else {
		// Handle error
		return
	}
            
	// Plot route on the map
	let routeOptions = PWRouteUIOptions()
	self?.mapView.navigate(with: route, options: routeOptions)
            
	// Initial route instructions
	self?.initializeTurnByTurn()
})
        
// Preset turn by turn view
func initializeTurnByTurn() {
	mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
	if turnByTurnCollectionView == nil {
   		turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
		turnByTurnCollectionView?.turnByTurnDelegate = self
		turnByTurnCollectionView?.configureInView(view)
	}
}
```

# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
