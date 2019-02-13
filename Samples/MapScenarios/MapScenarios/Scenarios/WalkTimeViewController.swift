//
//  TimeTraveledViewController.swift
//  MapScenarios
//
//  Created on 2/1/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWMapKit

class WalkTimeViewController: UIViewController {
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    
    // MARK: Walk Time
    // Walk speed is in meters/second
    var walkSpeed: Double {
        if let calculatedWalkSpeed = calculatedWalkSpeed, acceptedWalkSpeedRange.contains(calculatedWalkSpeed) {
            return calculatedWalkSpeed
        }
        return defaultWalkSpeed
    }
    let defaultWalkSpeed = 1.4
    var calculatedWalkSpeed: Double?
    let acceptedWalkSpeedRange = 0.5..<5.0
    var estimatedWalkTime: Double?
    var lastLocationUpdates = [CLLocation]()
    let walkTimeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Walk Time Calculation"
        
        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                self?.locationManager.delegate = self
                if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
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
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureWalkTimeLabel() {
        if walkTimeLabel.superview == nil {
            view.addSubview(walkTimeLabel)
            walkTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            walkTimeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            walkTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0).isActive = true
            walkTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10.0).isActive = true
            walkTimeLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
    }
    
    func updateWalkTimeLabel() {
        guard let distanceRemaining = mapView.remainingRouteDistanceFromCurrentLocation() else {
            walkTimeLabel.text = ""
            return
        }
        
        let estimatedWalkTimeInSeconds = distanceRemaining / walkSpeed
        let estimatedWalkTimeInMinutes = Int(ceil(estimatedWalkTimeInSeconds / 60.0))
        if estimatedWalkTimeInMinutes <= 1 {
            walkTimeLabel.text = "Under 1 minute til arrival"
        } else {
            walkTimeLabel.text = "\(estimatedWalkTimeInMinutes) minutes til arrival"
        }
    }
    
    func updateWalkSpeed(latestLocation: PWUserLocation) {
        lastLocationUpdates.append(CLLocation(coordinate: latestLocation.coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: latestLocation.timestamp))
        if lastLocationUpdates.count > 3 {
            lastLocationUpdates.remove(at: 0)
        }
        
        if let averageSpeed = calculateAverageSpeedFromLocationUpdates(lastLocationUpdates) {
            calculatedWalkSpeed = averageSpeed
        }
    }
    
    func calculateAverageSpeedFromLocationUpdates(_ locationUpdates: [CLLocation]) -> Double? {
        var averageSpeed: Double?
        for i in 1..<locationUpdates.count {
            let previousLocationUpdate = locationUpdates[i - 1]
            let locationUpdate = locationUpdates[i]
            let distance = locationUpdate.distance(from: previousLocationUpdate)
            let timeDifference = locationUpdate.timestamp.timeIntervalSince(previousLocationUpdate.timestamp)
            let speed = distance / timeDifference
            if acceptedWalkSpeedRange.contains(speed) {
                if let runningAverage = averageSpeed {
                    averageSpeed = (runningAverage + speed) / 2.0
                } else {
                    averageSpeed = speed
                }
            }
        }
        return averageSpeed
    }
}

// MARK: - PWMapViewDelegate

extension WalkTimeViewController: PWMapViewDelegate {
    
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
            
            PWRoute.createRoute(from: mapView.indoorUserLocation, to: destinationPOI, accessibility: false, excludedPoints: nil, completion: { [weak self] (route, error) in
                guard let route = route else {
                    print("Couldn't find a route from you current location to the destination.")
                    return
                }
                
                self?.configureWalkTimeLabel()
                let routeOptions = PWRouteUIOptions()
                mapView.navigate(with: route, options: routeOptions)
            })
        } else {
            updateWalkSpeed(latestLocation: userLocation)
            updateWalkTimeLabel()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WalkTimeViewController: CLLocationManagerDelegate {
    
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
