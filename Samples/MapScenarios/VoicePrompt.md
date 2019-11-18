## Sample - Voice Prompt
====================

### Overview
- This feature will read route instruction aloud to the user as they swipe through the route instructions or as they traverse them with indoor location.

### Usage

- Need to fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, and `destinationPOIIdentifier` in VoicePromptRouteViewController.swift.

### Sample Code
- [WalkTimeViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/WalkTime/WalkTimeViewController.swift)
- [VoicePromptRouteViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/Voice Prompt/VoicePromptRouteViewController.swift)
- [VoicePromptRouteViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/Voice Prompt/VoicePromptRouteViewController.swift)
- [VoicePromptButton.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/Voice Prompt/VoicePromptButton.swift)

**Step 1: Copy the following files to your project**

- VoicePromptRouteViewController.swift
- VoicePromptButton.xib

**Step 2: Add the following variables and methods to your view controller**

```
let voicePromptButton = VoicePromptButton()
let voicePromptsLabel = UILabel()
var previouslyReadInstructions = Set<PWRouteInstruction>()
private let speechEnabledKey = "SpeechEnabled"
var speechEnabled: Bool {
    get {
        if UserDefaults.standard.value(forKey: speechEnabledKey) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: speechEnabledKey)
    }
    set {
        UserDefaults.standard.set(newValue, forKey: speechEnabledKey)
    }
}
let speechSynthesizer = AVSpeechSynthesizer()
var instructionChangeCausedBySwipe = false
```

As well as the extension methods

```
// MARK: - Voice Prompt UI

extension VoicePromptRouteViewController {

    func configureVoiceUI() {
        configureVoicePromptsButton()
        configureVoicePromptsLabel()
        updateVoiceUI()
    }

    func configureVoicePromptsButton() {
        guard let turnByTurnView = turnByTurnCollectionView else {
            return
        }
        let voicePromptButtonHeight: CGFloat = 35.0
        voicePromptButton.backgroundImageColor = .white
        voicePromptButton.cornerRadius = voicePromptButtonHeight / 2.0
        view.addSubview(voicePromptButton)
        voicePromptButton.translatesAutoresizingMaskIntoConstraints = false
        voicePromptButton.topAnchor.constraint(equalTo: turnByTurnView.bottomAnchor, constant: 20.0).isActive = true
        voicePromptButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
        voicePromptButton.heightAnchor.constraint(equalToConstant: voicePromptButtonHeight).isActive = true
        voicePromptButton.widthAnchor.constraint(equalToConstant: voicePromptButtonHeight).isActive = true
        voicePromptButton.action = { [weak self] in
            self?.speechButtonTapped()
        }
    }

    func configureVoicePromptsLabel() {
        voicePromptsLabel.font = .systemFont(ofSize: 10.0)
        voicePromptsLabel.textAlignment = .center
        view.addSubview(voicePromptsLabel)
        voicePromptsLabel.translatesAutoresizingMaskIntoConstraints = false
        voicePromptsLabel.topAnchor.constraint(equalTo: voicePromptButton.bottomAnchor, constant: 2.0).isActive = true
        voicePromptsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40.0).isActive = true
        voicePromptsLabel.centerXAnchor.constraint(equalTo: voicePromptButton.centerXAnchor).isActive = true
    }

    func updateVoiceUI() {
        voicePromptsLabel.text = speechEnabled ? NSLocalizedString("Unmuted", comment: "muted label") : NSLocalizedString("Muted", comment: "muted label")
        voicePromptButton.buttonImage = speechEnabled ? #imageLiteral(resourceName: "Unmuted") : #imageLiteral(resourceName: "Muted")
        if speechEnabled {
            if let currentInstruction = mapView.currentRouteInstruction() {
                readInstructionAloud(currentInstruction)
            }
        } else {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }

    @objc
    func speechButtonTapped() {
        speechEnabled = !speechEnabled
        updateVoiceUI()
    }

    func readInstructionAloud(_ instruction: PWRouteInstruction) {
        let voicePrompt = instruction.instructionStringForUser()
        let utterance = AVSpeechUtterance(string: voicePrompt)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())

        DispatchQueue.main.async { [weak self] in
            self?.speechSynthesizer.stopSpeaking(at: .immediate)
            self?.speechSynthesizer.speak(utterance)
        }
    }
}

// MARK: - PWMapViewDelegate

extension VoicePromptRouteViewController: PWMapViewDelegate {

    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow

            let destinationPOIIdentifier = 4371243 /* Replace with the destination POI identifier */

            var destinationPOI: PWPointOfInterest!
            if destinationPOIIdentifier != 0 {
                destinationPOI = mapView.building.pois.first(where: { $0.identifier == destinationPOIIdentifier })
            } else {
                if let firstPOI = mapView.building.pois.first {
                    destinationPOI = firstPOI
                }
            }

            if destinationPOI == nil {
                print("No points of interest found, please add at least one to the building in the Maas portal")
                return
            }

            PWRoute.createRoute(from: mapView.indoorUserLocation, to: destinationPOI, accessibility: false, excludedPoints: nil, completion: { [weak self] (route, error) in
                guard let route = route else {
                    print("Couldn't find a route from you current location to the destination.")
                    return
                }

                mapView.navigate(with: route)
                self?.initializeTurnByTurn()
                self?.configureVoiceUI()
            })
        }
    }

    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        turnByTurnCollectionView?.scrollToInstruction(instruction)
        guard speechEnabled else {
            return
        }
        if !instructionChangeCausedBySwipe, previouslyReadInstructions.contains(instruction) {
            return
        } else if !instructionChangeCausedBySwipe {
            previouslyReadInstructions.insert(instruction)
        }
        instructionChangeCausedBySwipe = false // Clear state for next instruction change

        readInstructionAloud(instruction)
    }
}

// MARK: - TurnByTurnDelegate

extension VoicePromptRouteViewController: TurnByTurnDelegate {

    func didSwipeOnRouteInstruction() {
        instructionChangeCausedBySwipe = true
    }

    func instructionExpandTapped() {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.configure(mapView: mapView)
        routeInstructionViewController.presentFromViewController(self)
    }
}

// MARK: - CLLocationManagerDelegate

extension VoicePromptRouteViewController: CLLocationManagerDelegate {

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
