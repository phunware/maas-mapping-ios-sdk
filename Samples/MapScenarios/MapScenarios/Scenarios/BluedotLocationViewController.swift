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

class BluedotLocationViewController: UIViewController {
    
    let buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bluedot Location"
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                if let buildingIdentifier = self?.buildingIdentifier {
                    let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingIdentifier)
                    
                    DispatchQueue.main.async {
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
}

// MARK: - PWMapViewDelegate

extension BluedotLocationViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWIndoorLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
    }
}
