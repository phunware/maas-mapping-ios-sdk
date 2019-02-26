//
//  TimeTraveledViewController.swift
//  MapScenarios
//
//  Created by Xiangwei Wang on 2/1/19.
//  Copyright © 2019 Patrick Dunshee. All rights reserved.
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
    
    // If the blue dot sit on the route path
    var snappedLocation = false
    
    // The walk time view
    var walkTimeView: WalkTimeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Turn By Turn + Walk Time Navigation"
        mapView.delegate = self
        
        // Request location authentication
        clLocationManager = CLLocationManager()
        clLocationManager.delegate = self
        clLocationManager.requestAlwaysAuthorization()
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
        let distance = restDistance()
        
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
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.updateWalkTimeView()
        }
        
        // Set initial value
        walkTimeView.updateWalkTime(distance: distance)
    }
    
    func restDistance() -> CLLocationDistance {
        // Recaculate only when the blue dot is snapping on the route path
        guard let lastUpdateLocation = lastUpdateLocation, snappedLocation == true, let currentInstruction = self.mapView.currentRouteInstruction(), let currentIndex = self.mapView.currentRoute.routeInstructions.firstIndex(of: currentInstruction), let restInstructions = self.mapView.currentRoute.routeInstructions?[currentIndex...] else {
            return -1
        }
        
        var distance: CLLocationDistance = 0
        
        // The distance for rest of instructions
        for instruction in restInstructions {
            distance += instruction.distance
        }
        
        // The distance from current location to the end of current instruction
        if let instructionEndLocation = currentInstruction.points.last?.coordinate {
            let userLocation = CLLocation(latitude: lastUpdateLocation.coordinate.latitude, longitude: lastUpdateLocation.coordinate.longitude);
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
        snappedLocation = true
    }
    
    func mapViewStoppedSnappingLocation(toRoute mapView: PWMapView!) {
        snappedLocation = false
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
}
