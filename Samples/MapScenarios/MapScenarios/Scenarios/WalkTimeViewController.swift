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

// MARK: - WalkTimeViewController
class WalkTimeViewController: UIViewController, ScenarioProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier: Int = 0
    
    // Destination POI identifier for routing
    private var startPOIIdentifier: Int = 0
    private var destinationPOIIdentifier: Int = 0
    
    private let mapView = PWMapView()
    
    private var turnByTurnCollectionView: TurnByTurnCollectionView?
    
    // Track the list controller so we can notify it of walk time changes, since it also can display the walk time
    private var routeListController: RouteInstructionListViewController?
    
    // GPS location manager - used to request location authentication
    private let clLocationManager = CLLocationManager()
    
    // Last update location
    private var lastUpdateLocation: PWUserLocation?
    
    // If the blue dot is currently snapped to the route path
    private var snappingLocation = false
    
    // Average speed
    private var averageSpeed: CLLocationSpeed {
        get {
            if speedSamples.count > 0 {
                return speedSamples.reduce(0, +) / Double(speedSamples.count)
            } else {
                return 0.7
            }
        }
    }
    
    private var speedSamples = [CLLocationSpeed]()
    
    // The walk time view
    private var walkTimeView: WalkTimeView?
    
    // timer used to update the walk time view periodically
    private var walkTimeUpdateTimer: DispatchSourceTimer?
    
    // How often we recalculate the walk time
    private let walkTimeUpdateInterval: Int = 5
    
    // When within this distance to the destination, we consider the routing to be complete
    private let minDistanceToDestination: CLLocationDistance = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Walk Time Calculations"
        
        mapView.delegate = self
        
        if !validateScenarioSettings() {
            return
        }
        
        if startPOIIdentifier == destinationPOIIdentifier || destinationPOIIdentifier == 0 {
            warning("Please put valid data for 'startPOIIdentifier' and 'destinationPOIIdentifier'")
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        // Start loading building
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                if let error = error {
                    self?.warning(error.localizedDescription)
                    return
                }
                
                self?.startRoute()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        turnByTurnCollectionView?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        turnByTurnCollectionView?.isHidden = true
        super.viewWillDisappear(animated)
    }
}

// MARK: - WalkTimeViewDelegate
extension WalkTimeViewController: WalkTimeViewDelegate {
    func exitButtonPressed(for walkTimeView: WalkTimeView) {
        cancelWalkTimeUpdateTimer()
        self.walkTimeView?.removeFromSuperview()
        self.walkTimeView = nil
        turnByTurnCollectionView?.removeFromSuperview()
        mapView.cancelRouting()
    }
}

// MARK: - TurnByTurnCollectionViewDelegate
extension WalkTimeViewController: TurnByTurnCollectionViewDelegate {
    func turnByTurnCollectionViewInstructionExpandTapped(_ collectionView: TurnByTurnCollectionView) {
        let distance = walkTimeView?.remainingDistance ?? 0
        let averageSpeed = walkTimeView?.averageSpeed ?? 0
        
        let routeInstructionViewController = RouteInstructionListViewController()
        
        routeListController = routeInstructionViewController
        routeInstructionViewController.walkTimeViewDelegate = self
        
        routeInstructionViewController.configure(route: mapView.currentRoute,
                                                 walkTimeDisplayMode: .display(distance: distance, averageSpeed: averageSpeed))
        
        routeInstructionViewController.presentFromViewController(self)
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
        // automatically start tracking when we get the first location update
        if lastUpdateLocation == nil, userLocation != nil {
            mapView.trackingMode = .follow
        }
        
        lastUpdateLocation = userLocation
    }
    
    func mapViewStartedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = true
    }
    
    func mapViewStoppedSnappingLocation(toRoute mapView: PWMapView!) {
        snappingLocation = false
    }
    
    func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
        turnByTurnCollectionView?.scrollToInstruction(instruction)
        
        // cancel the timer
        cancelWalkTimeUpdateTimer()
        
        // update the walk time
        updateWalkTime()
        
        // restart the timer
        startWalkTimeUpdateTimer()
    }
    
    func mapView(_ mapView: PWMapView!, didFailToLocateIndoorUserWithError error: Error!) {
        guard let error = error as NSError? else {
            return
        }
        
        let title = error.domain
        let description = error.userInfo["message"] as? String ?? "Unknown Error"
        let message = "\(description) \n Error Code: \(error.code)"
        
        showAlertForIndoorLocationFailure(withTitle: title , failureMessage: message)
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
        guard let lastLocation = locations.last else {
            return
        }
        
        speedSamples.append(lastLocation.speed)
        
        let maxSamples = 5
        let count = speedSamples.count
        
        if speedSamples.count > maxSamples {
            speedSamples.removeFirst(count - maxSamples)
        }
    }
}

// MARK: - Walk Time Update Timer
private extension WalkTimeViewController {
    func startWalkTimeUpdateTimer() {
        let newTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        
        newTimer.schedule(deadline: DispatchTime.now() + TimeInterval(walkTimeUpdateInterval),
                          repeating: .seconds(walkTimeUpdateInterval))
        
        newTimer.setEventHandler { [weak self] in
            self?.updateWalkTime()
        }
        
        walkTimeUpdateTimer = newTimer
        newTimer.resume()
    }
    
    func cancelWalkTimeUpdateTimer() {
        walkTimeUpdateTimer?.cancel()
        walkTimeUpdateTimer = nil
    }
    
    func updateWalkTime() {
        // we need a valid instruction, the list of all instructions,
        // and the current instruction index before we can calculate anything
        guard let currentInstruction = mapView.currentRouteInstruction(),
            let allInstructions = mapView.currentRoute.routeInstructions,
            let currentInstructionIndex = allInstructions.firstIndex(of: currentInstruction) else {
                return
        }
        
        // Update blue dot walk time when snapping to route, and we have a valid user location, otherwise use static calculations.
        let distance: CLLocationDistance
        
        if snappingLocation, let lastUpdateLocation = lastUpdateLocation {
            distance = calculateBlueDotDistance(from: lastUpdateLocation,
                                                currentInstruction: currentInstruction,
                                                allInstructions: allInstructions,
                                                currentInstructionIndex: currentInstructionIndex)
            
            // When we're at the destination, we're done. Remove the walk time view
            if distance < minDistanceToDestination,
                let lastInstruction = mapView.currentRoute.routeInstructions.last,
                currentInstruction == lastInstruction {
                walkTimeView?.removeFromSuperview()
                return
            }
        } else {
            distance = calculateStaticDistance(currentInstruction: currentInstruction,
                                               allInstructions: allInstructions,
                                               currentInstructionIndex: currentInstructionIndex)
        }
        
        walkTimeView?.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
        routeListController?.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
    }
    
    func calculateStaticDistance(currentInstruction: PWRouteInstruction,
                                 allInstructions: [PWRouteInstruction],
                                 currentInstructionIndex: Int) -> CLLocationDistance {
        var distance: CLLocationDistance = 0
        
        let remainingInstructions = allInstructions[currentInstructionIndex...]
        
        for instruction in remainingInstructions {
            distance += instruction.distance
        }
        
        return distance
    }
    
    func calculateBlueDotDistance(from userLocation: PWUserLocation,
                                  currentInstruction: PWRouteInstruction,
                                  allInstructions: [PWRouteInstruction],
                                  currentInstructionIndex: Int) -> CLLocationDistance {
        var distance: CLLocationDistance = 0
        
        // The distance for the remaining instructions excluding the current one.
        let nextIndex = currentInstructionIndex + 1
        
        if nextIndex < allInstructions.count {
            let remainingInstructions = allInstructions[nextIndex...]
            
            for instruction in remainingInstructions {
                distance += instruction.distance
            }
        }
        
        // The distance from current location to the end of current instruction
        if let lastPoint = currentInstruction.points.last?.coordinate {
            let userLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let endLocation = CLLocation(latitude: lastPoint.latitude, longitude: lastPoint.longitude)
            distance += userLocation.distance(from: endLocation)
        }
        
        return distance
    }
}

// MARK: - private
private extension WalkTimeViewController {
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func layoutWalkTimeView() {
        let walkTimeView = Bundle.main.loadNibNamed(String(describing: WalkTimeView.self), owner: nil, options: nil)!.first as! WalkTimeView
        self.walkTimeView = walkTimeView
        walkTimeView.delegate = self
        
        mapView.addSubview(walkTimeView)
        
        walkTimeView.translatesAutoresizingMaskIntoConstraints = false
        walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        walkTimeView.heightAnchor.constraint(equalToConstant: WalkTimeView.defaultHeight).isActive = true
        walkTimeView.isHidden = true
        
        // Do an initial calculation of the walk time.
        updateWalkTime()
        
        // start our update timer so we can update the walk time periodically
        startWalkTimeUpdateTimer()
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
    
    func startRoute() {
        // Set tracking mode to follow me
        mapView.trackingMode = .follow
        
        // Find the destination POI
        guard let startPOI = mapView.building.pois.first(where: { $0.identifier == startPOIIdentifier }),
            let destinationPOI = mapView.building.pois.first(where: { $0.identifier == destinationPOIIdentifier }) else {
            warning("Please put valid data for 'startPOIIdentifier' and 'destinationPOIIdentifier'")
            return
        }
        
        // Calculate a route and plot on the map
        PWRoute.createRoute(from: startPOI,
                            to: destinationPOI,
                            options: nil,
                            completion: { [weak self] (route, error) in
            guard let self = self else {
                return
            }
                                
            guard let route = route else {
                self.warning("Couldn't find a route between POI(\(self.startPOIIdentifier)) and POI(\(self.destinationPOIIdentifier)).")
                return
            }
            
            // Plot route on the map
            let routeOptions = PWRouteUIOptions()
            self.mapView.navigate(with: route, options: routeOptions)
            
            // Initial route instructions
            self.initializeTurnByTurn()
        })
    }
    
    // called after route has been calculated
    func initializeTurnByTurn() {
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
        
        if turnByTurnCollectionView == nil {
            turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
            turnByTurnCollectionView?.turnByTurnDelegate = self
            turnByTurnCollectionView?.configureInView(view)
        }
        
        // Show walk time view when turn by turn is visible
        layoutWalkTimeView()
    }
}
