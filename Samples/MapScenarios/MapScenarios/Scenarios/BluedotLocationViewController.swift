//
//  BluedotLocationViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit
import PWCore

// MARK: - BluedotLocationViewController
class BluedotLocationViewController: UIViewController, ScenarioSettingsProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    private let mapView = PWMapView()
    private let locationManager = CLLocationManager()
    private var firstLocationAcquired = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bluedot Location"
        
        if !validateScenarioSettings() {
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
    
    func startManagedLocationManager() {
        DispatchQueue.main.async { [weak self] in
            guard let buildingIdentifier = self?.buildingIdentifier else {
                return
            }
            let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
            self?.mapView.register(managedLocationManager)
        }
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - PWMapViewDelegate
extension BluedotLocationViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension BluedotLocationViewController: CLLocationManagerDelegate {
    
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
