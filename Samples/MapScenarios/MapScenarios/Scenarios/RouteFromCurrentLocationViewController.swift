//
//  RouteFromCurrentLocationViewController.swift
//  MapScenarios
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWMapKit

// MARK: - RouteToPOIViewController
class RouteFromCurrentLocationViewController: UIViewController, ScenarioProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0

    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    
    private let mapView = PWMapView()
    private let locationManager = CLLocationManager()
    private var firstLocationAcquired = false
    private var routeButton: UIBarButtonItem?
    private var turnByTurnCollectionView: TurnByTurnCollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route from Current Location"
        
        if !validateScenarioSettings() {
            return
        }
                
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        configureRouteButton()
        
        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] (campus, error) in
                if let error = error {
                    self?.warning(error.localizedDescription)
                    return
                }

                self?.mapView.setCampus(campus, animated: true, onCompletion: { (error) in
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
        else {
            PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
                if let error = error {
                    self?.warning(error.localizedDescription)
                    return
                }

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
    }
    
    func startManagedLocationManager() {
        // In order to route between buildings on a campus, we also need to register the
        // PWManagedLocationManager using campusIdentifier.  Otherwise, we will register
        // using buildingIdentifier.
        if campusIdentifier != 0 {
            DispatchQueue.main.async { [weak self] in
                guard let campusIdentifier = self?.campusIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(campusId: campusIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                guard let buildingIdentifier = self?.buildingIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == String(describing: RouteViewController.self) {
            if let routeViewController = segue.destination as? RouteViewController {
                routeViewController.delegate = self
                routeViewController.mapView = mapView
                routeViewController.landmarkEnabled = false
                routeViewController.startFromCurrentLocation = true
            }
        }
    }
}
    
// MARK: - private
extension RouteFromCurrentLocationViewController {

    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureRouteButton() {
        let floorImage = UIImage(named: "RoadSign")
        routeButton = UIBarButtonItem(image: floorImage, style: .plain, target: self, action: #selector(routeButtonTapped))
        navigationItem.rightBarButtonItem = routeButton
    }
    
    func cancelRouting() {
        mapView.cancelRouting()
        routeButton?.image = UIImage(named: "RoadSign")
        routeButton?.title = nil
        turnByTurnCollectionView?.removeFromSuperview()
        turnByTurnCollectionView = nil
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

    @objc func routeButtonTapped() {
        // Set tracking mode to follow me
        mapView.trackingMode = .follow

        guard mapView.floors?.isEmpty == false else {
            return
        }
        
        if mapView.currentRoute != nil {
            cancelRouting()
        } else {
            performSegue(withIdentifier: String(describing: RouteViewController.self), sender: nil)
        }
    }
}

// MARK: - PWMapViewDelegate
extension RouteFromCurrentLocationViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
        }
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
    
    func mapView(_ mapView: PWMapView!, didChange floor: PWFloor!) {
        mapView.zoomToFitFloor(floor)
    }
}

// MARK: - CLLocationManagerDelegate
extension RouteFromCurrentLocationViewController: CLLocationManagerDelegate {
    
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

// MARK: - RouteViewDelegate

extension RouteFromCurrentLocationViewController: RouteViewDelegate {
    func routeSelected(_ route: PWRoute) {
        let routeUIOptions = PWRouteUIOptions()
        mapView.navigate(with: route, options: routeUIOptions)
        
        routeButton?.image = nil
        routeButton?.title = "Cancel"
        
        // Initial route instructions
        initializeTurnByTurn()
    }
}

// MARK: - TurnByTurnCollectionViewDelegate

extension RouteFromCurrentLocationViewController: TurnByTurnCollectionViewDelegate {
    func turnByTurnCollectionView(_ collectionView: TurnByTurnCollectionView, viewModelFor routeInstruction: PWRouteInstruction) -> InstructionViewModel {
        return BasicInstructionViewModel(for: routeInstruction)
    }
    
    func turnByTurnCollectionViewInstructionExpandTapped(_ collectionView: TurnByTurnCollectionView) {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.delegate = self
        routeInstructionViewController.configure(route: mapView.currentRoute)
        routeInstructionViewController.presentFromViewController(self)
    }
}

// MARK: - RouteInstructionListViewControllerDelegate

extension RouteFromCurrentLocationViewController: RouteInstructionListViewControllerDelegate {
    func routeInstructionListViewController(_ viewController: RouteInstructionListViewController, viewModelFor routeInstruction: PWRouteInstruction)
        -> InstructionViewModel {
        return BasicInstructionViewModel(for: routeInstruction)
    }
}
