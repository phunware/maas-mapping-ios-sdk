//
//  VoicedRouteViewController.swift
//  MapScenarios
//
//  Created on 2/5/19.
//  Copyright © 2019 Patrick Dunshee. All rights reserved.
//

import AVFoundation
import PWCore
import PWMapKit
import UIKit

class VoicedRouteViewController: UIViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
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
        configureSpeechButton()
        
        if applicationId.count > 0 && accessKey.count > 0 && signatureKey.count > 0 && buildingIdentifier != 0 {
            PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        } else {
            fatalError("applicationId, accessKey, signatureKey, and buildingIdentifier must be set")
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                if let buildingIdentifier = self?.buildingIdentifier {
                    DispatchQueue.main.async {
                        let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                        self?.mapView.register(managedLocationManager)
                    }
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
    
    // MARK: Voice Prompts Button
    
    func configureSpeechButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Speech", style: .plain, target: self, action: #selector(speechButtonTapped))
        updateSpeechButton()
    }
    
    func updateSpeechButton() {
        navigationItem.rightBarButtonItem?.tintColor = speechEnabled ? .blue : .darkGray
    }
    
    @objc
    func speechButtonTapped() {
        speechEnabled = !speechEnabled
        updateSpeechButton()
    }
}

// MARK: - PWMapViewDelegate

extension VoicedRouteViewController: PWMapViewDelegate {
    
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
                    destinationPOI = mapView.building.pois[2]
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
        utterance.voice = AVSpeechSynthesisVoice(language: "en-us")
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }
}

// MARK: - CLLocationManagerDelegate

extension VoicedRouteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startManagedLocationManager()
        default:
            print("Not authorized to start PWManagedLocationManager")
        }
    }
}

