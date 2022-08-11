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
class BluedotLocationViewController: UIViewController, ScenarioProtocol {
    
    // The following configurations override the universal configurations defined in ScenerioSelectViewController.
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0

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
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] result in
                switch result {
                case .success(let campus):
                    self?.mapView.setCampus(campus, animated: true, onCompletion: { (error) in
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
        else {
            PWBuilding.building(identifier: buildingIdentifier) { [weak self] result in
                switch result {
                case .success(let building):
                    self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
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
        }
        else {
            DispatchQueue.main.async { [weak self] in
                guard let buildingIdentifier = self?.buildingIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                self?.mapView.register(managedLocationManager)
            }
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
    
    func mapView(_ mapView: PWMapView!, didFailToLocateIndoorUserWithError error: Error!) {
        guard let error = error as NSError? else {
            return
        }
        
        let title = error.domain
        let description = error.userInfo["message"] as? String ?? "Unknown Error"
        let message = "\(description) \n Error Code: \(error.code)"
        
        showAlertForIndoorLocationFailure(withTitle: title , failureMessage: message)
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
