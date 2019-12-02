//
//  TurnByTurnLandmarksViewController.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 11/4/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWMapKit

// MARK: - TurnByTurnLandmarksViewController
class TurnByTurnLandmarksViewController: UIViewController, ScenarioSettingsProtocol {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route - Turn By Turn"
        
        if !validateScenarioSettings() {
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
extension TurnByTurnLandmarksViewController: TurnByTurnCollectionViewDelegate {
    func turnByTurnCollectionView(_ collectionView: TurnByTurnCollectionView, viewModelFor routeInstruction: PWRouteInstruction) -> InstructionViewModel {
        // We'll use the LandmarkInstructionViewModel to generate the view model for our collection view cells,
        // which will use the landmarks generated along with the route to augment the instruction text.
        return LandmarkInstructionViewModel(for: routeInstruction)
    }
    
    func turnByTurnCollectionViewInstructionExpandTapped(_ collectionView: TurnByTurnCollectionView) {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.delegate = self
        routeInstructionViewController.configure(route: mapView.currentRoute)
        routeInstructionViewController.presentFromViewController(self)
    }
}

// MARK: - RouteInstructionListViewControllerDelegate
extension TurnByTurnLandmarksViewController: RouteInstructionListViewControllerDelegate {
    func routeInstructionListViewController(_ viewController: RouteInstructionListViewController, viewModelFor routeInstruction: PWRouteInstruction)
        -> InstructionViewModel {
        return LandmarkInstructionViewModel(for: routeInstruction)
    }
}

// MARK: - private
private extension TurnByTurnLandmarksViewController {
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
        
        // Create a PWRouteOptions object with landmarksEnabled set to true so landmarks will be injected into route info (if available)
        let routeOptions = PWRouteOptions(accessibilityEnabled: false,
                                          landmarksEnabled: true,
                                          excludedPointIdentifiers: nil)
        
        // Calculate a route and plot on the map with our specified route options
        PWRoute.createRoute(from: startPOI,
                            to: destinationPOI,
                            options: routeOptions,
                            completion: { [weak self] (route, error) in
            guard let route = route else {
                self?.warning("Couldn't find a route between POI(\(self?.startPOIIdentifier ?? 0)) and POI(\(self?.destinationPOIIdentifier ?? 0)).")
                return
            }
            
            // Plot route on the map
            let uiOptions = PWRouteUIOptions()
            self?.mapView.navigate(with: route, options: uiOptions)
            
            // Initial route instructions
            self?.initializeTurnByTurn()
        })
    }
    
    func initializeTurnByTurn() {
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
        
        if turnByTurnCollectionView == nil {
            turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
            turnByTurnCollectionView?.turnByTurnDelegate = self
            turnByTurnCollectionView?.configureInView(view)
        }
    }
}
