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

class TurnByTurnViewController: UIViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier: Int = 0
    
    // Destination POI identifier for routing
    var startPOIIdentifier: Int = 0
    var destinationPOIIdentifier: Int = 0
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    var firstLocationAcquired = false
    
    var instructionsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
            return
        }
        
        if startPOIIdentifier == destinationPOIIdentifier || destinationPOIIdentifier == 0 {
            warning("Please put valid data for `startPOIIdentifier` and `destinationPOIIdentifier` in RoutingViewController.swift")
            return
        }
        
        navigationItem.title = "Turn By Turn Navigation"
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
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureTurnByTurnInstructionsView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        instructionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        instructionsCollectionView.showsHorizontalScrollIndicator = true
        instructionsCollectionView.isPagingEnabled = true
        instructionsCollectionView.bounces = true
        instructionsCollectionView.backgroundColor = .white
        instructionsCollectionView.delegate = self
        instructionsCollectionView.dataSource = self
        view.addSubview(instructionsCollectionView)
        
        instructionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        instructionsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64.0).isActive = true
        instructionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        instructionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        instructionsCollectionView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        let collectionViewCellIdentifier = String(describing: TurnByTurnInstructionCollectionViewCell.self)
        instructionsCollectionView.register(UINib(nibName: collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
    
    //*************************************
    // Plot route on the map
    //*************************************
    func startRoute() {
        // Set tracking mode to follow me
        mapView.trackingMode = .follow
        
        // Find the destination POI
        guard let startPOI = mapView.building.pois.first(where: { $0.identifier == startPOIIdentifier }), let destinationPOI = mapView.building.pois.first(where: { $0.identifier == destinationPOIIdentifier }) else {
            warning("Please put valid data for `startPOIIdentifier` and `destinationPOIIdentifier` in RoutingViewController.swift")
            return
        }
        
        // Calculate a route and plot on the map
        PWRoute.createRoute(from: startPOI, to: destinationPOI, accessibility: false, excludedPoints: nil, completion: { [weak self] (route, error) in
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
        configureTurnByTurnInstructionsView()
        
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions.first)
        instructionsCollectionView.reloadData()
        instructionsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension TurnByTurnViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(instructionsCollectionView.contentOffset.x / instructionsCollectionView.frame.size.width)
        mapView.setRouteManeuver(mapView.currentRoute.routeInstructions?[currentIndex])
    }
}

extension TurnByTurnViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let route = mapView.currentRoute, let routeInstructions = route.routeInstructions else {
            return 0
        }
        return routeInstructions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let routeInstructionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TurnByTurnInstructionCollectionViewCell.self), for: indexPath) as? TurnByTurnInstructionCollectionViewCell {
            if let route = mapView.currentRoute, let routeInstructions = route.routeInstructions, routeInstructions.count > indexPath.row {
                routeInstructionCollectionViewCell.routeInstruction = routeInstructions[indexPath.row]
            }
            cell = routeInstructionCollectionViewCell
        }
        return cell
    }
}

extension TurnByTurnViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
