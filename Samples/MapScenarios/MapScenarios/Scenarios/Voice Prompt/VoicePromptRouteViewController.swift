//
//  VoicedRouteViewController.swift
//  MapScenarios
//
//  Created on 2/5/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import AVFoundation
import PWCore
import PWMapKit
import UIKit

class VoicePromptRouteViewController: UIViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    var turnByTurnCollectionView: TurnByTurnCollectionView?
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Voice Prompts For Route", comment: "")
        
        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                self?.locationManager.delegate = self
                if !CLLocationManager.isAuthorized() {
                    self?.locationManager.requestWhenInUseAuthorization()
                } else {
                    self?.startManagedLocationManager()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        turnByTurnCollectionView?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        turnByTurnCollectionView?.isHidden = true
        super.viewWillDisappear(animated)
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func startManagedLocationManager() {
        DispatchQueue.main.async { [weak self] in
            if let buildingIdentifier = self?.buildingIdentifier {
                let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        }
    }
    
    func initializeTurnByTurn() {
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
        if turnByTurnCollectionView == nil {
            turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
            turnByTurnCollectionView?.turnByTurnDelegate = self
            turnByTurnCollectionView?.configureInView(view)
        }
    }
}

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
            
            let destinationPOIIdentifier = 0 /* Replace with the destination POI identifier */
            
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
            
            PWRoute.createRoute(from: mapView.indoorUserLocation,
                                to: destinationPOI,
                                options: nil,
                                completion: { [weak self] (route, error) in
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

