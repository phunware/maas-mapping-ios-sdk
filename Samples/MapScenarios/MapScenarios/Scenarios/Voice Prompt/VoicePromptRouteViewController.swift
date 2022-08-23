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

// MARK: - VoicePromptRouteViewController

class VoicePromptRouteViewController: UIViewController, ScenarioProtocol {
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    private let mapView = PWMapView()
    private var routeButton: UIBarButtonItem?
    private var turnByTurnCollectionView: TurnByTurnCollectionView?
    private let locationManager = CLLocationManager()
    private var firstLocationAcquired = false
    private let voicePromptButton = VoicePromptButton()
    private let voicePromptsLabel = UILabel()
    
    private let speechEnabledKey = "SpeechEnabled"
    
    private var speechEnabled: Bool {
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
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Voiced Route Instructions", comment: "")
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        configureRouteButton()
        
        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] result in
                switch result {
                case .success(let campus):
                    self?.mapView.setCampus(campus, animated: true, onCompletion: { _ in
                        self?.locationManager.delegate = self
                        if !CLLocationManager.isAuthorized() {
                            self?.locationManager.requestWhenInUseAuthorization()
                        } else {
                            self?.startManagedLocationManager()
                        }
                    })
                    
                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        } else {
            PWBuilding.building(identifier: buildingIdentifier) { [weak self] result in
                switch result {
                case .success(let building):
                    self?.mapView.setBuilding(building, animated: true, onCompletion: { _ in
                        self?.locationManager.delegate = self
                        if !CLLocationManager.isAuthorized() {
                            self?.locationManager.requestWhenInUseAuthorization()
                        } else {
                            self?.startManagedLocationManager()
                        }
                    })
                    
                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == String(describing: RouteViewController.self) {
            if let routeViewController = segue.destination as? RouteViewController {
                routeViewController.delegate = self
                routeViewController.mapView = mapView
                routeViewController.landmarkEnabled = false
                routeViewController.startFromCurrentLocation = true
            }
        }
    }
}

// MARK: - private

extension VoicePromptRouteViewController {
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureRouteButton() {
        let floorImage = UIImage(named: "RoadSign")
        routeButton = UIBarButtonItem(image: floorImage, style: .plain, target: self, action: #selector(routeButtonTapped))
        navigationItem.rightBarButtonItem = routeButton
    }
    
    func cancelRouting() {
        mapView.cancelRouting()
        routeButton?.image = UIImage(named: "RoadSign")
        routeButton?.title = nil
        turnByTurnCollectionView?.removeFromSuperview()
        turnByTurnCollectionView = nil
    }
    
    @objc func routeButtonTapped() {
        // Set tracking mode to follow me
        mapView.trackingMode = .follow
        
        guard mapView.floors?.isEmpty == false else {
            return
        }
        
        if mapView.currentRoute != nil {
            cancelRouting()
        } else {
            performSegue(withIdentifier: String(describing: RouteViewController.self), sender: nil)
        }
    }
    
    func startManagedLocationManager() {
        // In order to route between buildings on a campus, we also need to register the
        // PWManagedLocationManager using campusIdentifier.  Otherwise, we will register
        // using buildingIdentifier.
        if campusIdentifier != 0 {
            DispatchQueue.main.async { [weak self] in
                guard let campusIdentifier = self?.campusIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(campusId: campusIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let buildingIdentifier = self?.buildingIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        }
    }
    
    func initializeTurnByTurn() {
        guard let routeInstructions = mapView.currentRoute.routeInstructions else {
            return
        }
        mapView.setRouteManeuver(routeInstructions.first)
        
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
        voicePromptsLabel.text = speechEnabled
            ? NSLocalizedString("Unmuted", comment: "muted label")
            : NSLocalizedString("Muted", comment: "muted label")
        
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
        let directionsViewModel = BasicInstructionViewModel(for: instruction)
        let voicePrompt = directionsViewModel.voicePrompt
        
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
        }
    }
    
    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        turnByTurnCollectionView?.scrollToInstruction(instruction)
        
        if speechEnabled {
            readInstructionAloud(instruction)
        }
    }
    
    func mapView(_ mapView: PWMapView!, didFailToLocateIndoorUserWithError error: Error!) {
        guard let error = error as NSError? else {
            return
        }
        
        let title = error.domain
        let description = error.userInfo["message"] as? String ?? "Unknown Error"
        let message = "\(description) \n Error Code: \(error.code)"
        
        showAlertForIndoorLocationFailure(withTitle: title, failureMessage: message)
    }
}

// MARK: - TurnByTurnCollectionViewDelegate

extension VoicePromptRouteViewController: TurnByTurnCollectionViewDelegate {
    func turnByTurnCollectionViewInstructionExpandTapped(_ collectionView: TurnByTurnCollectionView) {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.configure(route: mapView.currentRoute)
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

// MARK: - RouteViewDelegate

extension VoicePromptRouteViewController: RouteViewDelegate {
    func routeSelected(_ route: PWRoute) {
        let routeUIOptions = PWRouteUIOptions()
        mapView.navigate(with: route, options: routeUIOptions)
        
        routeButton?.image = nil
        routeButton?.title = "Cancel"
        
        initializeTurnByTurn()
        configureVoiceUI()
    }
}
