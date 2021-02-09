//
//  LoadBuildingViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import PWMapKit
import PWCore

// MARK: - LoadBuildingViewController
class LoadBuildingViewController: UIViewController, ScenarioProtocol {
    
    @IBOutlet private weak var floorSwitchContainerView: UIView!
    @IBOutlet private weak var floorSwitchPickerView: UIPickerView!

    private var firstFloorSwitch = false
    private var floorSwitchFloors = [PWFloor]()
    private var floorSwitchBuildings = [PWBuilding]()

    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0

    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    // The starting center coordinate for the camera view. Set this to be the location of your building
    // (or close to it) so that the camera will already be close to the building location before the building loads.
    private let initialCenterCoordinate = CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129)
    
    // The how many meters the camera will display of the map from the center point.
    // Set to a lower value if you would like the camera to start zoomed in more.
    private let initialCameraDistance: CLLocationDistance = 10000000
    
    private let mapView = PWMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Load Building"
        
        firstFloorSwitch = false
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
                
        view.addSubview(mapView)
        configureMapViewConstraints()
        mapView.delegate = self
        
        configureFloorSwitchButton()
        configureFloorSwitchContainerView()

        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] (campus, error) in
                if let error = error {
                    self?.warning(error.localizedDescription)
                    return
                }
                
                self?.mapView.setCampus(campus, animated: true, onCompletion: nil)
            }
        }
        else {
            PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
                if let error = error {
                    self?.warning(error.localizedDescription)
                    return
                }
                
                self?.mapView.setBuilding(building, animated: true, onCompletion: nil)
            }
        }
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureFloorSwitchContainerView() {
        self.view.bringSubviewToFront(floorSwitchContainerView)
        floorSwitchContainerView.isHidden = true
    }
    
    func configureFloorSwitchButton() {
        let floorImage = UIImage(named: "Floors")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: floorImage, style: .plain, target: self, action: #selector(floorButtonTapped))
    }
}

// MARK: - User Actions
extension LoadBuildingViewController {
    
    @IBAction func floorButtonTapped(_ sender: UIBarButtonItem) {
        floorSwitchBuildings.removeAll()
        floorSwitchFloors.removeAll()
        
        guard let floors = mapView.floors, !floors.isEmpty else {
            floorSwitchContainerView.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        guard floorSwitchContainerView.isHidden else {
            floorSwitchContainerView.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        var floorSwitchBuildings = [PWBuilding]()
        var floorSwitchFloors = [PWFloor]()
        
        if let campus = mapView.campus {
            if let buildings = campus.buildings {
                floorSwitchBuildings.append(contentsOf: buildings)
            }
        } else if let building = mapView.building {
            floorSwitchBuildings.append(building)
        }
        
        guard !floorSwitchBuildings.isEmpty else {
            floorSwitchContainerView.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        let buildingIndex = floorSwitchBuildings.firstIndex { (building) -> Bool in
            return building.identifier == mapView.currentFloor?.building?.identifier
        }
        
        guard let currentBuildingIndex = buildingIndex else {
            floorSwitchContainerView.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        if let currentBuildingFloors = floorSwitchBuildings[currentBuildingIndex].floors {
            floorSwitchFloors.append(contentsOf: currentBuildingFloors)
        }
        
        let floorIndex = floorSwitchFloors.firstIndex { (floor) -> Bool in
            return floor.floorID == mapView.currentFloor?.floorID
        }
        
        self.floorSwitchBuildings.append(contentsOf: floorSwitchBuildings)
        self.floorSwitchFloors.append(contentsOf: floorSwitchFloors)
        
        floorSwitchPickerView.reloadAllComponents()
        
        floorSwitchPickerView.selectRow(currentBuildingIndex, inComponent: Components.building, animated: false)
        
        if let currentFloorIndex = floorIndex {
            floorSwitchPickerView.selectRow(currentFloorIndex, inComponent: Components.floor, animated: false)
        }
        
        floorSwitchContainerView.isHidden = false
    }
}


// MARK: - UIPickerViewDelegate
extension LoadBuildingViewController: UIPickerViewDelegate {
    
    private var buildingComponentWidth: CGFloat {
        return floorSwitchPickerView.frame.width / 2 //* (1 / 3.0)
    }

    private var floorComponentWidth: CGFloat {
        return floorSwitchPickerView.frame.width / 2 //* (2 / 3.0)
    }
    
    private var componentHeight: CGFloat {
        return 40
    }
    
    private var rowWidthMargin: CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == Components.building ? buildingComponentWidth : floorComponentWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return componentHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel
        
        if let reusableLabel = view as? UILabel {
            label = reusableLabel
        } else {
            let frame: CGRect
            let textAlignment: NSTextAlignment

            if component == Components.building {
                frame = .init(origin: .zero, size: .init(width: buildingComponentWidth - rowWidthMargin, height: componentHeight))
                textAlignment = .right
            } else if component == Components.floor {
                frame = .init(origin: .zero, size: .init(width: floorComponentWidth - rowWidthMargin, height: componentHeight))
                textAlignment = .left
            } else {
                frame = .zero
                textAlignment = .left
            }
            
            label = UILabel(frame: frame)
            label.textColor = .black
            label.textAlignment = textAlignment
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 13, weight: .medium)
        }
        
        if component == Components.building {
            label.text = floorSwitchBuildings[row].name
        } else if component == Components.floor {
            label.text = floorSwitchFloors[row].name
        } else {
            label.text = nil
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == Components.building {
            floorSwitchFloors.removeAll()
            
            guard let floors = floorSwitchBuildings[row].floors, let firstFloor = floors.first else {
                pickerView.reloadComponent(Components.floor)
                return
            }
            
            floorSwitchFloors.append(contentsOf: floors)

            pickerView.reloadComponent(Components.floor)

            pickerView.selectRow(0, inComponent: Components.floor, animated: false)
            
            mapView.currentFloor = firstFloor
        } else if component == Components.floor {
            mapView.currentFloor = floorSwitchFloors[row]
        }
    }
}


// MARK: - UIPickerViewDataSource
extension LoadBuildingViewController: UIPickerViewDataSource {
    
    private enum Components {
        
        static let building = 0
        static let floor = 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberOfRows: Int
        
        if component == Components.building {
            numberOfRows = floorSwitchBuildings.count
        } else if component == Components.floor {
            numberOfRows = floorSwitchFloors.count
        } else {
            numberOfRows = 0
        }
        
        return numberOfRows
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
