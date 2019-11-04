//
//  WalkTimeViewController.swift
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
    let clLocationManager = CLLocationManager()
    
    // Last update location
    var lastUpdateLocation: PWUserLocation?
    
    // If the blue dot is currently snapped to the route path
    var snappingLocation = false
    var firstLocationAcquired = false
    
    // Average speed
    var averageSpeed: CLLocationSpeed {
        get {
            if speedArray.count > 0 {
                return speedArray.reduce(0, +) / Double(speedArray.count)
            } else {
                return 0.7
            }
        }
    }
    var speedArray = [CLLocationSpeed]()
    
    // The walk time view
    var walkTimeView: WalkTimeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Walk Time Calculations"
        
        mapView.delegate = self
        
        NotificationCenter.default.addObserver(forName: .ExitWalkTimeButtonTapped, object: nil, queue: nil) { [weak self] (_) in
            self?.walkTimeView?.removeFromSuperview()
            self?.walkTimeView = nil
            self?.turnByTurnCollectionView?.removeFromSuperview()
            self?.mapView.cancelRouting()
        }
    }
    
    override func initializeTurnByTurn() {
        super.initializeTurnByTurn()

        // Show walk time view when turn by turn is visible
        configureWalkTimeView()
    }
    
    override func instructionExpandTapped() {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.configure(mapView: mapView, walkTimeView: walkTimeView)
        routeInstructionViewController.presentFromViewController(self)
    }
    
    func configureWalkTimeView() {
        if let walkTimeView = Bundle.main.loadNibNamed(String(describing: WalkTimeView.self), owner: nil, options: nil)?.first as? WalkTimeView {
            mapView.addSubview(walkTimeView)
            
            // Layout
            walkTimeView.translatesAutoresizingMaskIntoConstraints = false
            walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            walkTimeView.heightAnchor.constraint(equalToConstant: WalkTimeView.defaultHeight).isActive = true
            walkTimeView.isHidden = true
            
            self.walkTimeView = walkTimeView
            
            updateStaticWalkTimeView(instruction: nil)
            
            updateWalkTimeView()
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
    
    func updateStaticWalkTimeView(instruction: PWRouteInstruction?) {
        guard let firstInstruction = mapView.currentRouteInstruction() else {
            return
        }
        var instructionToUse = firstInstruction
        if let instruction = instruction {
            instructionToUse = instruction
        }
        if lastUpdateLocation == nil, let currentIndex = self.mapView.currentRoute.routeInstructions.firstIndex(of: instructionToUse), let remainingInstructions = self.mapView.currentRoute.routeInstructions?[currentIndex...] {
            var distance: Double = 0
            for instruction in remainingInstructions {
                distance += instruction.distance
            }
            self.walkTimeView?.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
        }
    }
    
    func updateWalkTimeView() {
        // Update every 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.updateWalkTimeView()
        }
        
        let distance = remainingDistance()
        guard let walkTimeView = walkTimeView, distance >= 0 else {
            return
        }
        
        // Remove it when it's approaching the destination
        if distance < 5, let currentInstruction = mapView.currentRouteInstruction(), let lastInstruction = mapView.currentRoute.routeInstructions.last, currentInstruction == lastInstruction {
            walkTimeView.removeFromSuperview()
            return
        }
        
        // Set initial value
        walkTimeView.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
        
        NotificationCenter.default.post(name: .WalkTimeChanged, object: nil, userInfo: [NotificationUserInfoKeys.remainingDistance : distance, NotificationUserInfoKeys.averageSpeed : averageSpeed])
    }
    
    func remainingDistance() -> CLLocationDistance {
        // Recalculate only when the blue dot is snapping on the route path
        guard let lastUpdateLocation = lastUpdateLocation, snappingLocation == true, let currentInstruction = self.mapView.currentRouteInstruction(), let instructions = self.mapView.currentRoute.routeInstructions, let currentIndex = instructions.firstIndex(of: currentInstruction) else {
            return -1
        }
        
        var distance: CLLocationDistance = 0
        
        // The distance for the remaining instructions
        let remainingInstructions = instructions[(currentIndex+1)...]
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
    
    func mapView(_ mapView: PWMapView!, didFinishLoading building: PWBuilding!) {
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.activityType = .fitness
        clLocationManager.distanceFilter = kCLDistanceFilterNone
        if !CLLocationManager.isAuthorized() {
            clLocationManager.requestWhenInUseAuthorization()
        } else {
            startManagedLocationManager()
        }
    }
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        lastUpdateLocation = userLocation
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
    }
    
    func mapViewStartedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = true
    }
    
    func mapViewStoppedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = false
    }
    
    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        turnByTurnCollectionView?.scrollToInstruction(instruction)
        updateStaticWalkTimeView(instruction: instruction)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            speedArray.append(location.speed)
            while speedArray.count > 5 {
                speedArray.remove(at: 0)
            }
        }
    }
}
