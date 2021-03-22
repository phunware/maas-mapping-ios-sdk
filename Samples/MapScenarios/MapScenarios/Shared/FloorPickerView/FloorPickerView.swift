//
//  FloorPickerView.swift
//  MapScenarios
//
//  Created by Kent Tu on 2/11/21.
//  Copyright © 2021 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

// MARK: - FloorPickerView
class FloorPickerView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var floorSwitchPickerView: UIPickerView!
    var mapView: PWMapView?
    
    private var floorSwitchFloors = [PWFloor]()
    private var floorSwitchBuildings = [PWBuilding]()


    func configureInView(_ view: UIView, withMapView mapView: PWMapView) {
        if superview == nil {
            self.mapView = mapView
            self.isHidden = true
            
            configureFloorPickerView(view)
            configureFloorSwitchButton(view)
        }
    }
    
    @objc func floorButtonTapped(_ sender: UIBarButtonItem) {
        floorSwitchBuildings.removeAll()
        floorSwitchFloors.removeAll()
        
        guard let mapView = self.mapView, let floors = mapView.floors, !floors.isEmpty else {
            self.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        guard self.isHidden else {
            self.isHidden = true
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
            self.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        let buildingIndex = floorSwitchBuildings.firstIndex { (building) -> Bool in
            building.identifier == mapView.currentFloor?.building?.identifier
        }
        
        guard let currentBuildingIndex = buildingIndex else {
            self.isHidden = true
            floorSwitchPickerView.reloadAllComponents()
            return
        }
        
        if let currentBuildingFloors = floorSwitchBuildings[currentBuildingIndex].floors {
            floorSwitchFloors.append(contentsOf: currentBuildingFloors)
        }
        
        let floorIndex = floorSwitchFloors.firstIndex { (floor) -> Bool in
            floor.floorID == mapView.currentFloor?.floorID
        }
        
        self.floorSwitchBuildings.append(contentsOf: floorSwitchBuildings)
        self.floorSwitchFloors.append(contentsOf: floorSwitchFloors)
        
        floorSwitchPickerView.reloadAllComponents()
        
        floorSwitchPickerView.selectRow(currentBuildingIndex, inComponent: Components.building, animated: false)
        
        if let currentFloorIndex = floorIndex {
            floorSwitchPickerView.selectRow(currentFloorIndex, inComponent: Components.floor, animated: false)
        }
        
        self.isHidden = false
    }

    
}

// MARK: - Private

private extension FloorPickerView {
    func configureFloorSwitchButton(_ view: UIView) {
        let floorImage = UIImage(named: "Floors")
        let floorButton = UIButton()
        floorButton.setImage(floorImage, for: .normal)
        floorButton.addTarget(self, action: #selector(floorButtonTapped), for: .touchUpInside)
        floorButton.frame = CGRect(x: view.bounds.maxX - 50, y: 0, width: 50, height: 50)
        floorButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        view.addSubview(floorButton)
    }
    
    func configureFloorPickerView(_ view: UIView) {
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
// MARK: - UIPickerViewDelegate

extension FloorPickerView: UIPickerViewDelegate {
    private var buildingComponentWidth: CGFloat {
        return floorSwitchPickerView.frame.width / 2
    }
    
    private var floorComponentWidth: CGFloat {
        return floorSwitchPickerView.frame.width / 2
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
        guard let mapView = self.mapView else {
            return
        }
        
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

extension FloorPickerView: UIPickerViewDataSource {
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
