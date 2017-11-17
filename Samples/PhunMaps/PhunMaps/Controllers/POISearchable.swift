//
//  POISearchViewModel.swift
//  Mapping-Sample
//
//  Created on 6/20/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

protocol POISearchable: class {
    
    var tableView: UITableView! { get set }
    var filteredPOIs: [PWPointOfInterest]! { get set }
    var sectionedPOIs: [String : [PWPointOfInterest]]! { get set }
    var sortedSectionedPOIKeys: [String]! { get set }
    
    func search(keyword: String?)
    func buildSectionedPOIs()
}

extension POISearchable {
    
    func search(keyword: String?) {
        search(keyword: keyword, pointsToExclude: nil, poiType: nil)
    }
    
    func search(keyword: String?, pointsToExclude: [PWPointOfInterest]?) {
        search(keyword: keyword, pointsToExclude: pointsToExclude, poiType: nil)
    }
    
    func search(keyword: String?, pointsToExclude: [PWPointOfInterest]?, poiType: PWPointOfInterestType?) {
        guard let building = ConfigurationManager.shared.currentConfiguration.loadedBuilding, let floors = building.floors as? [PWFloor] else {
            print("No building loaded")
            return
        }
        
        var pois = [PWPointOfInterest]()
        for floor in floors {
            if let floorPOIs = floor.pointsOfInterest(of: poiType, containing: keyword) as? [PWPointOfInterest] {
                pois.append(contentsOf: floorPOIs)
            }
        }
        
        if let pointsToExclude = pointsToExclude {
            pois = pois.filter({ (pointOfInterest) -> Bool in
                for excludedPoint in pointsToExclude {
                    if excludedPoint.identifier == pointOfInterest.identifier {
                        return false
                    }
                }
                return true
            })
        }
        
        filteredPOIs = pois.sorted(by: {
            guard let title0 = $0.title, let title1 = $1.title else {
                return false
            }
            return title0.lowercased() < title1.lowercased()
        })
        
        buildSectionedPOIs()
        tableView.reloadData()
    }
    
    func buildSectionedPOIs() {
        sectionedPOIs.removeAll()
        for pointOfInterest in filteredPOIs {
            if let title = pointOfInterest.title, let firstChar = title.first {
                let firstCharString = String(describing: firstChar)
                if sectionedPOIs[firstCharString] != nil {
                    var sectionPOI = sectionedPOIs[firstCharString]!
                    sectionPOI.append(pointOfInterest)
                    sectionedPOIs[firstCharString] = sectionPOI
                } else {
                    sectionedPOIs[firstCharString] = [pointOfInterest]
                }
            }
        }
        
        sortedSectionedPOIKeys = sectionedPOIs.keys.sorted(by: {
            $0.lowercased() < $1.lowercased()
        })
    }
}
