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
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route to Point of Interest"
        
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
}

// MARK: - PWMapViewDelegate

extension RoutingViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
            
            let destinationPOIIdentifier = 0 /* Replace with the destination POI identifier */
            
            var destinationPOI: PWPointOfInterest!
            if destinationPOIIdentifier != 0 {
                destinationPOI = mapView.building.pois.filter({
                    return $0.identifier == destinationPOIIdentifier
                }).first
            } else {
                if let firstPOI = mapView.building.pois.first {
                    destinationPOI = firstPOI
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
                
                let routeOptions = PWRouteUIOptions()
//                routeOptions.routeStrokeColor = <#routeStrokeColor#>
//                routeOptions.directionFillColor = <#directionFillColor#>
//                routeOptions.directionStrokeColor = <#directionStrokeColor#>
//                routeOptions.instructionFillColor = <#instructionFillColor#>
//                routeOptions.instructionStrokeColor = <#instructionStrokeColor#>
//                routeOptions.showJoinPoint = <#true or false#>
//                routeOptions.joinPointColor = <#joinPointColor#>
//                routeOptions.lineJoin = <#.miter, round or bevel#>
                mapView.navigate(with: route, options: routeOptions)
            })
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
            print("Not authorized to start PWManagedLocationManager")
        }
    }
}