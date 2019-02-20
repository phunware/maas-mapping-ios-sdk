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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route to Point of Interest"
        
        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
            return
        }
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        configureVoiceUI()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                self?.locationManager.delegate = self
                if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                    self?.locationManager.requestWhenInUseAuthorization()
                } else {
                    self?.startManagedLocationManager()
                }
            })
        }
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
}

// MARK: - Voice Prompt UI

extension VoicePromptRouteViewController {
    
    func configureVoiceUI() {
        configureVoicePromptsButton()
        configureVoicePromptsLabel()
        updateVoiceUI()
    }
    
    func configureVoicePromptsButton() {
        let voicePromptButtonHeight: CGFloat = 35.0
        voicePromptButton.backgroundImageColor = .white
        voicePromptButton.cornerRadius = voicePromptButtonHeight / 2.0
        view.addSubview(voicePromptButton)
        voicePromptButton.translatesAutoresizingMaskIntoConstraints = false
        voicePromptButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        voicePromptButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
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
    }
    
    @objc
    func speechButtonTapped() {
        speechEnabled = !speechEnabled
        updateVoiceUI()
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
            
            PWRoute.createRoute(from: mapView.indoorUserLocation, to: destinationPOI, accessibility: false, excludedPoints: nil, completion: { (route, error) in
                guard let route = route else {
                    print("Couldn't find a route from you current location to the destination.")
                    return
                }
                
                mapView.navigate(with: route)
            })
        }
    }
    
    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        guard let movement = instruction.movement, speechEnabled, !previouslyReadInstructions.contains(instruction) else {
            return
        }
        previouslyReadInstructions.insert(instruction)
        var voicePrompt = "\(movement)"
        if let turn = instruction.turn {
            voicePrompt = voicePrompt + ", then \(turn)"
        }
        let utterance = AVSpeechUtterance(string: voicePrompt)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
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

