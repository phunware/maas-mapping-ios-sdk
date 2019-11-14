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

// MARK: - LoadBuildingViewController
class LoadBuildingViewController: UIViewController, ScenarioSettingsProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    // The starting center coordinate for the camera view. Set this to be the location of your building
    // (or close to it) so that the camera will already be close to the building location before the building loads.
    private let initialCenterCoordinate = CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129)
    
    // The how many meters the camera will display of the map from the center point.
    // Set to a lower value if you would like the camera to start zoomed in more.
    private let initialCameraDistance: CLLocationDistance = 10000000
    
    private let mapView = PWMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Load Building"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        
        // Set initial camera region
        let region = MKCoordinateRegion(center: initialCenterCoordinate, latitudinalMeters: initialCameraDistance, longitudinalMeters: initialCameraDistance)
        mapView.setRegion(region, animated: false)
        
        view.addSubview(mapView)
        configureMapViewConstraints()
        
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
