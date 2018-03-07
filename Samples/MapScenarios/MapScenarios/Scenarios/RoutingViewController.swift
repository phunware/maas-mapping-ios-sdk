//
//  RoutingViewController.swift
//  MapScenarios
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWMapKit

class RoutingViewController: UIViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    let applicationId = ""
    let accessKey = ""
    let signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route to Point of Interest"
        
        if applicationId.count > 0 && accessKey.count > 0 && signatureKey.count > 0 {
            PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        }
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                if let buildingIdentifier = self?.buildingIdentifier {
                    let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                    
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

extension RoutingViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWIndoorLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
            
            let destinationPOIIdentifier = 42539739 /* Replace with the destination POI identifier */
            
            // Plot the route from your current location
            let destinationPOI = mapView.building.pois.filter({
                if let poi = $0 as? PWPointOfInterest {
                    return poi.identifier == destinationPOIIdentifier
                } else {
                    return false
                }
            }).first as? PWPointOfInterest
            
            if destinationPOI == nil {
                print("You specified `destinationPOIIdentifier = \(destinationPOIIdentifier)` POI not found.")
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
}
