//
//  PWRouteInstruction+Maneuver.swift
//  MapScenarios
//
//  Created on 2/25/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

extension PWRouteInstruction {
    func floor(for point: PWMapPoint?) -> PWFloor? {
        guard let building = route?.building,
            let floorIdentifier = point?.floorID,
            let floor = building.floor(byId: floorIdentifier) else {
                return nil
        }
        
        return floor
    }
    
    func getNextInstruction() -> PWRouteInstruction? {
        guard let route = route,
            let indexOfInstruction = route.routeInstructions.firstIndex(of: self) else {
            return nil
        }
        
        let nextInstructionIndex = indexOfInstruction + 1
        
        if nextInstructionIndex < route.routeInstructions.count {
            return route.routeInstructions[nextInstructionIndex]
        } else {
            return nil
        }
    }
}
