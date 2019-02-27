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

class WalkTimeViewController: TurnByTurnViewController {
    
    // GPS location manager - used to request location authentication
    var clLocationManager: CLLocationManager!
    
    // Last update location
    var lastUpdateLocation: PWUserLocation?
    
    // If the blue dot is currently snapped to the route path
    var snappingLocation = false
    
    // Average speed
    var averageSpeed: CLLocationSpeed?
    var speedArray = [CLLocationSpeed]()
    
    // The walk time view
    var walkTimeView: WalkTimeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Turn By Turn + Walk Time Navigation"
        mapView.delegate = self
        
        // Request location authentication
        clLocationManager = CLLocationManager()
        clLocationManager.delegate = self
        clLocationManager.requestWhenInUseAuthorization()
        NotificationCenter.default.addObserver(forName: .ExitWalkTimeButtonTapped, object: nil, queue: nil) { [weak self] (_) in
            self?.walkTimeView?.removeFromSuperview()
            self?.walkTimeView = nil
        }
    }
    
    override func initializeTurnByTurn() {
        super.initializeTurnByTurn()

        // Show walk time view when turn by turn is visable
        configureWalkTimeView()
    }
    
    func configureWalkTimeView() {
        if let walkTimeView = Bundle.main.loadNibNamed(String(describing: WalkTimeView.self), owner: nil, options: nil)?.first as? WalkTimeView {
            view.addSubview(walkTimeView)
            
            // Layout
            walkTimeView.translatesAutoresizingMaskIntoConstraints = false
            walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            walkTimeView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            walkTimeView.isHidden = true
            
            self.walkTimeView = walkTimeView
            
            updateWalkTimeView()
        }
    }
    
    func updateWalkTimeView() {
        let distance = remainingDistance()
        
        guard let walkTimeView = walkTimeView, distance >= 0 else {
            return
        }
        
        // Remove it when it's approaching the destination
        if distance < 5, let currentInstruction = mapView.currentRouteInstruction(), let lastInstruction = mapView.currentRoute.routeInstructions.last, currentInstruction == lastInstruction {
            walkTimeView.removeFromSuperview()
            return
        }
        
        // Update every 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.updateWalkTimeView()
        }
        
        // Set initial value
        walkTimeView.updateWalkTime(distance: distance)
    }
    
    func remainingDistance() -> CLLocationDistance {
        // Recaculate only when the blue dot is snapping on the route path
        guard let lastUpdateLocation = lastUpdateLocation, snappingLocation == true, let currentInstruction = self.mapView.currentRouteInstruction(), let currentIndex = self.mapView.currentRoute.routeInstructions.firstIndex(of: currentInstruction), let remainingInstructions = self.mapView.currentRoute.routeInstructions?[currentIndex...] else {
            return -1
        }
        
        var distance: CLLocationDistance = 0
        
        // The distance for the remaining instructions
        for instruction in remainingInstructions {
            distance += instruction.distance
        }
        
        // The distance from current location to the end of current instruction
        if let instructionEndLocation = currentInstruction.points.last?.coordinate {
            let userLocation = CLLocation(latitude: lastUpdateLocation.coordinate.latitude, longitude: lastUpdateLocation.coordinate.longitude)
            let endLocation = CLLocation(latitude: instructionEndLocation.latitude, longitude: instructionEndLocation.longitude)
            distance += userLocation.distance(from: endLocation)
        }
        
        return distance
    }
}

// MARK: - PWMapViewDelegate

extension WalkTimeViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        lastUpdateLocation = userLocation
    }
    
    func mapViewStartedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = true
    }
    
    func mapViewStoppedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = false
    }
    
    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        // Update walk time when blue dot is not acquired
        if lastUpdateLocation == nil, let currentIndex = self.mapView.currentRoute.routeInstructions.firstIndex(of: instruction), let remainingInstructions = self.mapView.currentRoute.routeInstructions?[currentIndex...] {
            var distance: Double = 0
            for instruction in remainingInstructions {
                distance += instruction.distance
            }
            self.walkTimeView?.updateWalkTime(distance: distance, averageSpeed: 0)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WalkTimeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Re-register location manager
            mapView.unregisterLocationManager()
            let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
            DispatchQueue.main.async { [weak self] in
                self?.mapView.register(managedLocationManager)
            }
        default:
            print("Not authorized to start PWManagedLocationManager")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            speedArray.append(location.speed)
            while speedArray.count > 5 {
                speedArray.remove(at: 0)
            }
        }
    }
}
