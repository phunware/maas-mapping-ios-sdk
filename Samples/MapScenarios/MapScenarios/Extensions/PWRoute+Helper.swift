//
//  PWRoute+Helper.swift
//  MapScenarios
//
//  Created on 2/12/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

extension PWRoute {
    
    func closestInstructionTo(_ location: PWMapPoint) -> PWRouteInstruction? {
        let instructionsOnFloor = routeInstructions.filter({ $0.points.contains(where: { $0.floorID == location.floorID })})
        var closestInstruction: PWRouteInstruction?
        var closestPointDistance: CLLocationDistance?
        let mapPoint = MKMapPoint(location.coordinate)
        for instruction in instructionsOnFloor {
            guard instruction.polyline != nil else {
                continue
            }
            let distance = mapPoint.distanceTo(instruction.polyline)
            if let closestDistance = closestPointDistance, distance < closestDistance {
                closestPointDistance = distance
                closestInstruction = instruction
            } else if closestInstruction == nil {
                closestPointDistance = distance
                closestInstruction = instruction
            }
        }
        return closestInstruction
    }
}
