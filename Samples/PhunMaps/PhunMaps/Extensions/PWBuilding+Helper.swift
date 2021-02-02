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
            allPOIs.append(contentsOf: floor.pointsOfInterest)
        }
        return allPOIs
    }
    
    func availablePOITypes() -> [PWPointOfInterestType] {
        var allPOITypes = Set<PWPointOfInterestType>()
        for poi in allPOIs() {
            if let pointOfInterestType = poi.pointOfInterestType {
                allPOITypes.insert(pointOfInterestType)
            }
        }
        
        let sortedPOITypes = allPOITypes.sorted(by: {
            return $0.name < $1.name
        })
        return sortedPOITypes
    }
}
