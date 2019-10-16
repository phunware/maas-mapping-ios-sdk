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

class OffRouteViewController: UIViewController {

    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""

    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal

    let destinationPOIIdentifier = 0 /* Replace with the destination POI identifier */

    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    var currentRoute: PWRoute?
    let offRouteDistanceThreshold: CLLocationDistance = 10.0 //distance in meters
    let offRouteTimeThreshold: TimeInterval = 15.0 //time in seconds
    var offRouteTimer: Timer? = nil
    var modalVisible = false
    var dontShowAgain = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Off Route Alerts & Rerouting"

        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
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

    func buildRoute() {
        dontShowAgain = false

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

        PWRoute.createRoute(from: mapView.indoorUserLocation,
                            to: destinationPOI,
                            options: nil,
                            completion: { [weak self] (route, error) in
            if (route != nil) {
                self?.currentRoute = route
            } else {
                print("Couldn't find a route from you current location to the destination.")
                return
            }

            let routeOptions = PWRouteUIOptions()
            self?.mapView.navigate(with: route, options: routeOptions)
        })
    }

    @objc func fireTimer() {
        offRouteTimer?.invalidate()
        offRouteTimer = nil
        showModal()
    }

    private func showModal() {
        if (!modalVisible) {
            modalVisible = true

            let offRouteModal = OffRouteModalViewController()
            offRouteModal.modalPresentationStyle = .overCurrentContext
            offRouteModal.modalTransitionStyle = .crossDissolve

            offRouteModal.dismissCompletion = { [weak self] in
                self?.modalVisible = false
            }

            offRouteModal.rerouteCompletion = { [weak self] in
                self?.modalVisible = false
                self?.mapView.cancelRouting()
                self?.currentRoute = nil
                self?.buildRoute()
            }

            offRouteModal.dontShowAgainCompletion = { [weak self] in
                self?.modalVisible = false
                self?.dontShowAgain = true
            }

            present(offRouteModal, animated: true, completion: nil)
        }
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
            if (!modalVisible && !dontShowAgain) {
                if let closestRouteInstruction = self.currentRoute?.closestInstructionTo(userLocation) {
                    let distanceToRouteInstruction = MKMapPoint(userLocation.coordinate).distanceTo(closestRouteInstruction.polyline)
                    if (distanceToRouteInstruction > 0.0) {
                        if (distanceToRouteInstruction >= offRouteDistanceThreshold) {
                            offRouteTimer?.invalidate()
                            showModal()
                        } else {
                            if (offRouteTimer == nil) {
                                offRouteTimer = Timer.scheduledTimer(timeInterval: offRouteTimeThreshold, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
                            }
                        }
                    } else {
                        if (offRouteTimer != nil) {
                            offRouteTimer?.invalidate()
                            offRouteTimer = nil
                        }
                    }
                }
            }
        }
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
