//
//  FloorChangePOI.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/17/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

enum FloorChangePOI: Int {
    case stairs = 20001
    case elevator = 20000
    case escalator = 20003

    init?(mapPoint: PWMapPoint) {
        // only PWPointOfInterest objects have a 'pointOfInterestType' property
        guard let poi = mapPoint as? PWPointOfInterest, let poiType = poi.pointOfInterestType else {
            return nil
        }
        
        self.init(rawValue: poiType.identifier)
    }
}
