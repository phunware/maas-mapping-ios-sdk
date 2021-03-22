//
//  PWRouteInstruction+Helper.swift
//  Mapping-Sample
//
//  Created on 6/20/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

extension PWRouteInstruction {
    func isFloorChange() -> Bool {
        let floorChangeDirections = [PWRouteInstructionDirection.stairsUp, .stairsDown, .elevatorUp, .elevatorDown]
        return floorChangeDirections.contains(movementDirection)
    }
    
    func isLastInstruction() -> Bool {
        if let lastInstruction = route?.routeInstructions?.last {
            return lastInstruction == self
        }
        return false
    }
    
    func nextInstruction() -> PWRouteInstruction? {
        guard let routeInstructions = route?.routeInstructions,
              !isLastInstruction() else {
            return nil
        }

        return routeInstructions[indexOfInstruction() + 1]
    }
    
    func indexOfInstruction() -> Int {
        guard  let routeInstructions = route?.routeInstructions else {
            return 0
        }
        
        let index = routeInstructions.firstIndex(where: { (item) -> Bool in
            return item == self
        })
        return index ?? 0
    }
    
    func turnAngleToFaceHeadingFrom(currentBearing: CLLocationDirection) -> Double {
        return (fmod(fmod((currentBearing - movementTrueHeading), 360) + 540, 360) - 180) * -1
    }
}
