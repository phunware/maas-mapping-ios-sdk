//
//  TurnByTurnViewController.swift
//  MapScenarios
//
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWMapKit

class TurnByTurnViewController: UIViewController, ScenarioCredentialsProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier: Int = 0
    
    // Destination POI identifier for routing
    var startPOIIdentifier: Int = 0
    var destinationPOIIdentifier: Int = 0
    
    private let mapView = PWMapView()
    
    private var turnByTurnCollectionView: TurnByTurnCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route - Turn By Turn"
        
        if !validateScenarioCredentials() {
            return
        }
        
        if startPOIIdentifier == destinationPOIIdentifier || destinationPOIIdentifier == 0 {
            warning("Please put valid data for `startPOIIdentifier` and `destinationPOIIdentifier` in RoutingViewController.swift")
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

// MARK: - TurnByTurnCollectionViewDelegate
extension TurnByTurnViewController: TurnByTurnCollectionViewDelegate {
    func instructionExpandTapped() {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.directionsDelegate = self
        routeInstructionViewController.configure(route: mapView.currentRoute)
        routeInstructionViewController.presentFromViewController(self)
    }
    
    func didSwipeOnRouteInstruction() { }
}

// MARK: - DirectionsDisplayDelegate
extension TurnByTurnViewController: DirectionsDelegate {
    func directions(for instruction: PWRouteInstruction) -> DirectionsViewModel {
        return StandardDirectionsViewModel(for: instruction)
    }
}

// MARK: - private
private extension TurnByTurnViewController {
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func startRoute() {
        // Set tracking mode to follow me
        mapView.trackingMode = .follow
        
        // Find the destination POI
        guard let startPOI = mapView.building.pois.first(where: { $0.identifier == startPOIIdentifier }),
            let destinationPOI = mapView.building.pois.first(where: { $0.identifier == destinationPOIIdentifier }) else {
            warning("Please put valid data for `startPOIIdentifier` and `destinationPOIIdentifier` in RoutingViewController.swift")
            return
        }
        
        let routeOptions = PWRouteOptions(accessibilityEnabled: false,
                                          landmarksEnabled: true,
                                          excludedPointIdentifiers: nil)
        
        // Calculate a route and plot on the map
        PWRoute.createRoute(from: startPOI,
                            to: destinationPOI,
                            options: routeOptions,
                            completion: { [weak self] (route, error) in
            guard let route = route else {
                self?.warning("Couldn't find a route between POI(\(self?.startPOIIdentifier ?? 0)) and POI(\(self?.destinationPOIIdentifier ?? 0)).")
                return
            }
            
            // Plot route on the map
            let routeOptions = PWRouteUIOptions()
            self?.mapView.navigate(with: route, options: routeOptions)
            
            // Initial route instructions
            self?.initializeTurnByTurn()
        })
    }
    
    func initializeTurnByTurn() {
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
        
        if turnByTurnCollectionView == nil {
            turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
            turnByTurnCollectionView?.turnByTurnDelegate = self
            turnByTurnCollectionView?.directionsDelegate = self
            turnByTurnCollectionView?.configureInView(view)
        }
    }
}
