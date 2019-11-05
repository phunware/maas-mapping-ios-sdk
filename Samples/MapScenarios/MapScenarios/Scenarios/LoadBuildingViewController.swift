//
//  LoadBuildingViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import PWMapKit
import PWCore

class LoadBuildingViewController: UIViewController, ScenarioSettingsProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Load Building"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        // Set the starting coordinate for the map to be somewhat close to our building, so we don't start out
        // with a map of the whole US at first before we zoom in to the building location.
        let initialCenterCoordinate = CLLocationCoordinate2D(latitude: 30.361224, longitude: -97.744081)
        let spanInMeters: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: initialCenterCoordinate, latitudinalMeters: spanInMeters, longitudinalMeters: spanInMeters)
        mapView.setRegion(region, animated: false)
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                self.warning(error.localizedDescription)
                return
            }
            
            self.mapView.setBuilding(building, animated: true, onCompletion: nil)
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
