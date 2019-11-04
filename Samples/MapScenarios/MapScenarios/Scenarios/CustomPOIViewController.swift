//
//  CustomPOIViewController.swift
//  MapScenarios
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit
import PWCore

class CustomPOIViewController: UIViewController, ScenarioSettingsProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Custom Point Of Interest"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { [weak self] (error) in
                self?.addCustomPointOfInterest()
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
    
    func addCustomPointOfInterest() {
        let poiLocation = CLLocationCoordinate2DMake(30.359931, -97.742507)
        let poiTitle = "Custom POI"
        
        // If the image parameter is nil, it will use the POI icon for any specified `pointOfInterestType`. If no image is set and no `pointOfInterestType` is set, the SDK will use this default icon: https://lbs-prod.s3.amazonaws.com/stock_assets/icons/0_higher.png
        let customPOI = PWCustomPointOfInterest(coordinate: poiLocation, floor: mapView.currentFloor, title: poiTitle, image: nil)
        
        customPOI?.isShowTextLabel = true
        
        if let customPOI = customPOI {
            mapView.addAnnotation(customPOI)
        }
    }
}
