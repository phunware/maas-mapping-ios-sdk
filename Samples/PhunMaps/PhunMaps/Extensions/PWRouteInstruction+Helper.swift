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
        if let lastInstruction = route.routeInstructions.last {
            return lastInstruction == self
        }
        return false
    }
    
    func nextInstruction() -> PWRouteInstruction? {
        if isLastInstruction() {
            return nil
        } else {
            return route.routeInstructions[indexOfInstruction() + 1]
        }
    }
    
    func indexOfInstruction() -> Int {
        let index = route.routeInstructions.index(where: { (item) -> Bool in
            return item == self
        })
        return index ?? 0
    }
    
    func turnAngleToFaceHeadingFrom(currentBearing: CLLocationDirection) -> Double {
        return (fmod(fmod((currentBearing - movementTrueHeading), 360) + 540, 360) - 180) * -1
    }
}
