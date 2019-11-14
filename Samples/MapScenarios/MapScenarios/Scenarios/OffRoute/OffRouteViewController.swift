//
//  OffRouteViewController.swift
//  MapScenarios
//
//  Created by 2/25/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import UIKit
import PWCore
import PWMapKit

// MARK: - OffRouteViewController
class OffRouteViewController: UIViewController, ScenarioSettingsProtocol {

    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""

    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0

    // Replace with the destination POI identifier
    private let destinationPOIIdentifier = 0

    private let mapView = PWMapView()
    private var turnByTurnCollectionView: TurnByTurnCollectionView?
    
    private let locationManager = CLLocationManager()
    private var firstLocationAcquired = false
    private var currentRoute: PWRoute?
    
    private let offRouteDistanceThreshold: CLLocationDistance = 10.0 //distance in meters
    private let offRouteTimeThreshold: TimeInterval = 5.0 //time in seconds
    private var offRouteTimer: Timer? = nil
    
    private let offRouteMessageCooldownInterval = 10.0 //time in seconds
    private var lastTimeOffRouteMessageWasDismissed: Date?
    
    private var isOffRouteAlertCooldownActive: Bool {
        guard let lastTime = lastTimeOffRouteMessageWasDismissed else {
            return false
        }
        
        return Date().timeIntervalSince(lastTime) < offRouteMessageCooldownInterval
    }
    
    private var modalVisible = false
    private var dontShowAgain = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Off Route Scenario"

        if !validateScenarioSettings() {
            return
        }

        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        mapView.delegate = self
        mapView.routeSnappingTolerance = PWRouteSnapTolerance.toleranceNormal
        view.addSubview(mapView)
        configureMapViewConstraints()

        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                self?.locationManager.delegate = self
                if !CLLocationManager.isAuthorized() {
                    self?.locationManager.requestWhenInUseAuthorization()
                } else {
                    self?.startManagedLocationManager()
                }
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

    @objc func offRouteTimerExpired() {
        offRouteTimer?.invalidate()
        offRouteTimer = nil
        showOffRouteMessage()
    }
}

// MARK: - CLLocationManagerDelegate
extension OffRouteViewController: CLLocationManagerDelegate {

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

// MARK: - TurnByTurnCollectionViewDelegate
extension OffRouteViewController: TurnByTurnCollectionViewDelegate {
    
    func turnByTurnCollectionViewInstructionExpandTapped(_ collectionView: TurnByTurnCollectionView) {
        let routeInstructionViewController = RouteInstructionListViewController()
        routeInstructionViewController.configure(route: mapView.currentRoute)
        routeInstructionViewController.presentFromViewController(self)
    }
}

// MARK: - PWMapViewDelegate
extension OffRouteViewController: PWMapViewDelegate {

    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow

            self.buildRoute()
        } else {
            if !modalVisible, !dontShowAgain, !isOffRouteAlertCooldownActive {
                if let closestRouteInstruction = self.currentRoute?.closestInstructionTo(userLocation) {
                    let distanceToRouteInstruction = MKMapPoint(userLocation.coordinate).distanceTo(closestRouteInstruction.polyline)
                    
                    if distanceToRouteInstruction > 0.0 {
                        if (distanceToRouteInstruction >= offRouteDistanceThreshold) {
                            offRouteTimer?.invalidate()
                            showOffRouteMessage()
                        } else if offRouteTimer == nil {
                            offRouteTimer = Timer.scheduledTimer(timeInterval: offRouteTimeThreshold,
                                                                 target: self,
                                                                 selector: #selector(offRouteTimerExpired),
                                                                 userInfo: nil,
                                                                 repeats: false)

                        }
                    } else {
                        offRouteTimer?.invalidate()
                        offRouteTimer = nil
                    }
                }
            }
        }
    }
}

// MARK: - OffRouteModalViewControllerDelegate
extension OffRouteViewController: OffRouteModalViewControllerDelegate {
    func offRouteAlert(_ alert: OffRouteModalViewController, dismissedWithResult result: OffRouteModalViewController.Result) {
        lastTimeOffRouteMessageWasDismissed = Date()
        modalVisible = false
        
        switch result {
        case .dismiss:
            break
            
        case .reroute:
            mapView.cancelRouting()
            currentRoute = nil
            buildRoute()
            
        case .dontShowAgain:
            dontShowAgain = true
        }
    }
}



// MARK: - private
private extension OffRouteViewController {
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
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func initializeTurnByTurn() {
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
        
        if turnByTurnCollectionView == nil {
            turnByTurnCollectionView = TurnByTurnCollectionView(mapView: mapView)
            turnByTurnCollectionView?.turnByTurnDelegate = self
            turnByTurnCollectionView?.configureInView(view)
        }
    }

    func getDestinationPOI() -> PWPointOfInterest? {
        if destinationPOIIdentifier != 0 {
            return mapView.building.pois.first(where: { $0.identifier == destinationPOIIdentifier })
        } else {
            return mapView.building.pois.first
        }
    }
    
    func buildRoute() {
        dontShowAgain = false

        guard let destinationPOI = getDestinationPOI() else {
            print("No points of interest found, please add at least one to the building in the Maas portal")
            return
        }

        // Calculate a route and plot on the map
        PWRoute.createRoute(from: mapView.indoorUserLocation, to: destinationPOI, options: nil, completion: { [weak self] (route, error) in
            guard let self = self else {
                return
            }
            
            guard let route = route else {
                print("Couldn't find a route from you current location to the destination.")
                return
            }
        
            self.currentRoute = route


            let routeOptions = PWRouteUIOptions()
            self.mapView.navigate(with: route, options: routeOptions)
            
            self.initializeTurnByTurn()
        })
    }

    func showOffRouteMessage() {
        guard modalVisible == false else {
            return
        }

        modalVisible = true

        let offRouteModal = OffRouteModalViewController()
        offRouteModal.modalPresentationStyle = .overCurrentContext
        offRouteModal.modalTransitionStyle = .crossDissolve
        offRouteModal.delegate = self

        present(offRouteModal, animated: true, completion: nil)
    }
}
