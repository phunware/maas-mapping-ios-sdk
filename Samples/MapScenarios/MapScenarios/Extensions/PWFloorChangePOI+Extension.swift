//
//  PWFloorChangePOI+Extension.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/17/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

extension PWFloorChangePOI {
    init?(mapPoint: PWMapPoint) {
        // only PWPointOfInterest objects have a 'pointOfInterestType' property
        guard let poi = mapPoint as? PWPointOfInterest, let poiType = poi.pointOfInterestType else {
            return nil
        }
        
        switch poiType.identifier {
        case PWFloorChangePOI.stairs.rawValue:
            self = .stairs
        case PWFloorChangePOI.elevator.rawValue:
            self = .elevator
        case PWFloorChangePOI.escalator.rawValue:
            self = .escalator
        default:
            return nil
        }
    }
}
