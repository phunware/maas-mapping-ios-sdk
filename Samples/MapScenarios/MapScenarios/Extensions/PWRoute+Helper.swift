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
        let clLocation = CLLocation(coordinate: location.coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
        var closestInstruction: PWRouteInstruction?
        var closestPointDistance: CLLocationDistance?
        for instruction in instructionsOnFloor {
            for point in instruction.points {
                let pointLocation = CLLocation(coordinate: point.coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
                let distance = clLocation.distance(from: pointLocation)
                if let closestDistance = closestPointDistance, distance < closestDistance {
                    closestPointDistance = distance
                    closestInstruction = instruction
                } else if closestInstruction == nil {
                    closestPointDistance = distance
                    closestInstruction = instruction
                }
            }
        }
        return closestInstruction
    }
}
