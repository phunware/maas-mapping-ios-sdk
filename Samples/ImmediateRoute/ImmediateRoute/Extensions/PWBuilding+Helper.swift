//
//  PWBuilding+Helper.swift
//  Mapping-Sample
//
//  Created on 7/19/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import PWMapKit

extension PWBuilding {
    
    func allPOIs() -> [PWPointOfInterest] {
        var allPOIs = [PWPointOfInterest]()
        for floor in floors {
            if let floor = floor as? PWFloor, let pointsOfInterest = floor.pointsOfInterest as? [PWPointOfInterest] {
                allPOIs.append(contentsOf: pointsOfInterest)
            }
        }
        return allPOIs
    }
    
    func availablePOITypes() -> [PWPointOfInterestType] {
        var allPOITypes = Set<PWPointOfInterestType>()
        for poi in allPOIs() {
            allPOITypes.insert(poi.pointOfInterestType)
        }
        
        let sortedPOITypes = allPOITypes.sorted(by: {
            return $0.name < $1.name
        })
        return sortedPOITypes
    }
}
