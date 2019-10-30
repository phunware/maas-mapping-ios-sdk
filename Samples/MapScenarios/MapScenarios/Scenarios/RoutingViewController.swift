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
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    // Destination POI identifier for routing
    var destinationPOIIdentifier: Int = 0
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route to Point of Interest"
        
        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
            return
        }
        
        if destinationPOIIdentifier == 0 {
            warning("Please set a valid value for `destinationPOIIdentifier` in RoutingViewController.swift")
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        // Start loading building
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                if let error = error {
                    self?.warning(error.localizedDescription)
                    return
                }
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
            if let buildingIdentifier = self?.buildingIdentifier {
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
    
    //*************************************
    // Plot route on the map
    //*************************************
    func route() {
        // Set tracking mode to follow me
        mapView.trackingMode = .follow
        
        // Find the destination POI
        let destinationPOI = mapView.building.pois.filter({
            return $0.identifier == destinationPOIIdentifier
        }).first
        if destinationPOI == nil {
            warning("No points of interest found, please add at least one to the building in the Maas portal")
            return
        }
        
        // Calculate a route and plot on the map
        PWRoute.createRoute(from: mapView.indoorUserLocation,
                            to: destinationPOI,
                            options: nil,
                            completion: { [weak self] (route, error) in
            guard let route = route else {
                self?.warning("Couldn't find a route from you current location to the destination.")
                return
            }
            
            let routeOptions = PWRouteUIOptions()
            // routeOptions.routeStrokeColor = <#routeStrokeColor#>
            // routeOptions.directionFillColor = <#directionFillColor#>
            // routeOptions.directionStrokeColor = <#directionStrokeColor#>
            // routeOptions.instructionFillColor = <#instructionFillColor#>
            // routeOptions.instructionStrokeColor = <#instructionStrokeColor#>
            // routeOptions.showJoinPoint = <#true or false#>
            // routeOptions.joinPointColor = <#joinPointColor#>
            // routeOptions.lineJoin = <#.miter, round or bevel#>
            self?.mapView.navigate(with: route, options: routeOptions)
        })
    }
}

// MARK: - PWMapViewDelegate

extension RoutingViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            route()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension RoutingViewController: CLLocationManagerDelegate {
    
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
