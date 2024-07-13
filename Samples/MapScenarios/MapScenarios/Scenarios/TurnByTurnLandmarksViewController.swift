//
//  TurnByTurnLandmarksViewController.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 11/4/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWCore
import PWMapKit
import UIKit

// MARK: - TurnByTurnLandmarksViewController

class TurnByTurnLandmarksViewController: UIViewController, ScenarioProtocol {
    // Enter your application identifier and access key found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier: Int = 0
    
    private let mapView = PWMapView()
    
    private var turnByTurnCollectionView: TurnByTurnCollectionView?
    private var routeButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route with Landmarks"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
        
        view.addSubview(mapView)
        configureMapViewConstraints()
        configureRouteButton()
        
        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] result in
                switch result {
                case .success(let campus):
                    self?.mapView.setCampus(campus, animated: true, onCompletion: nil)

                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        } else {
            // Start loading building
            PWBuilding.building(identifier: buildingIdentifier) { [weak self] result in
                switch result {
                case .success(let building):
                    self?.mapView.setBuilding(building, animated: true, onCompletion: nil)

                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        turnByTurnCollectionView?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == String(describing: RouteViewController.self) {
            if let routeViewController = segue.destination as? RouteViewController {
                routeViewController.delegate = self
                routeViewController.mapView = mapView
                routeViewController.landmarkEnabled = true
            }
        }
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
    
    func cancelRouting() {
        mapView.cancelRouting()
        routeButton?.image = UIImage(named: "RoadSign")
        routeButton?.title = nil
        turnByTurnCollectionView?.removeFromSuperview()
        turnByTurnCollectionView = nil
    }
    
    func configureRouteButton() {
        let floorImage = UIImage(named: "RoadSign")
        routeButton = UIBarButtonItem(image: floorImage, style: .plain, target: self, action: #selector(routeButtonTapped))
        navigationItem.rightBarButtonItem = routeButton
    }
    
    @objc func routeButtonTapped() {
        guard mapView.floors?.isEmpty == false else {
            return
        }
        
        if mapView.currentRoute != nil {
            cancelRouting()
        } else {
            performSegue(withIdentifier: String(describing: RouteViewController.self), sender: nil)
        }
    }
    
    func initializeTurnByTurn() {
        if let currentRoute = mapView.currentRoute,
            let routeInstructions = currentRoute.routeInstructions {
            mapView.setRouteManeuver(routeInstructions.first)
        }
        
        if turnByTurnCollectionView == nil {
            turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
            turnByTurnCollectionView?.turnByTurnDelegate = self
            turnByTurnCollectionView?.configureInView(view)
        }
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

// MARK: - RouteViewDelegate

extension TurnByTurnLandmarksViewController: RouteViewDelegate {
    func routeSelected(_ route: PWRoute) {
        let routeUIOptions = PWRouteUIOptions()
        mapView.navigate(with: route, options: routeUIOptions)
        
        routeButton?.image = nil
        routeButton?.title = "Cancel"
        
        // Initial route instructions
        initializeTurnByTurn()
    }
}
