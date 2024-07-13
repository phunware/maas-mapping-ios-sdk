//
//  LoadBuildingViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import PWCore
import PWMapKit

// MARK: - LoadBuildingViewController

class LoadBuildingViewController: UIViewController, ScenarioProtocol {
    @IBOutlet private var floorSwitchContainerView: UIView!
    @IBOutlet private var floorSwitchPickerView: UIPickerView!
    
    private var firstFloorSwitch = false
    
    // Enter your application identifier and access key found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    private let mapView = PWMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Load Building"
        
        firstFloorSwitch = false
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
        
        view.addSubview(mapView)
        configureMapViewConstraints()
        mapView.delegate = self
        addFloorPickerView()
                
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
}

// MARK: - User Actions

extension LoadBuildingViewController {
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addFloorPickerView() {
        let bundleName = String(describing: FloorPickerView.self)
        let floorPickerView = Bundle.main.loadNibNamed(bundleName, owner: nil, options: nil)!.first as! FloorPickerView
        floorPickerView.configureInView(view, withMapView: mapView)
    }
}

// MARK: - PWMapViewDelegate

extension LoadBuildingViewController: PWMapViewDelegate {
    func mapView(_ mapView: PWMapView!, didChange floor: PWFloor!) {
        guard firstFloorSwitch else {
            firstFloorSwitch = true
            return
        }
        
        mapView.zoomToFitFloor(floor)
    }
}
