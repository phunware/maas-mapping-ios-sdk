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
        guard  let routeInstructions = routeInstructions else {
            return nil
        }
        
        var instructionsOnFloor = routeInstructions.filter({ $0.points.contains(where: { $0.floorID == location.floorID })})
        if instructionsOnFloor.isEmpty {
            instructionsOnFloor = instructionsOnFloorAtSameLevelTo(location)
        }

        var closestInstruction: PWRouteInstruction?
        var closestPointDistance: CLLocationDistance?
        let mapPoint = MKMapPoint(location.coordinate)
        for instruction in instructionsOnFloor {
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
        
    private func instructionsOnFloorAtSameLevelTo(_ location: PWMapPoint) -> [PWRouteInstruction] {
        guard  let routeInstructions = routeInstructions else {
            return []
        }
        
        var instructionsOnFloor: [PWRouteInstruction] = []

        if let floorsAtSameLevelToLocation = floorsAtSameLevelTo(location) {
            let floorsInRouteInstructions = routeInstructions.map {$0.start.floorID} + routeInstructions.map {$0.end.floorID}
            let floorsWithInstructionClosestToLocation = Set(floorsAtSameLevelToLocation).intersection(Set(floorsInRouteInstructions))
            if floorsWithInstructionClosestToLocation.count > 0 {
                instructionsOnFloor = routeInstructions.filter({ (routeInstruction: PWRouteInstruction) -> Bool in
                    return floorsWithInstructionClosestToLocation.contains(where: { (floor: Int) -> Bool in
                        return routeInstruction.points.contains(where: {$0.floorID == floor})
                    })
                })
            }
        }
        return instructionsOnFloor
    }
    
    private func floorsAtSameLevelTo(_ location: PWMapPoint) -> [Int]? {
        
        guard let currentFloor = campus?.floorById(location.floorID),
              let currentFloorPointsOfInterest = currentFloor.pointsOfInterest,
              let pois = campus?.pois
        else {
            return nil
        }
        
        let portalsForCurrentFloor = currentFloorPointsOfInterest.filter {$0.isBuildingToBuildingPortal()}
        let portalsForCampus = pois.filter {$0.isBuildingToBuildingPortal()}
        
        var portalsAtSameLevel : [PWPointOfInterest] = portalsForCurrentFloor
        var floorsAtSameLevel = [currentFloor.floorID]
        var portalsToSearch = portalsForCampus.filter {$0.buildingID != currentFloor.building.identifier}
        
        var found = false
        repeat {
            found = false
            for portal in portalsToSearch {
                if portalsAtSameLevel.contains(where: {$0.portalID == portal.portalID}) {
                    if !floorsAtSameLevel.contains(portal.floorID) {
                        floorsAtSameLevel.append(portal.floorID)
                        let poisOfFloor = portalsForCampus.filter {$0.floorID == portal.floorID}
                        portalsAtSameLevel.append(contentsOf: poisOfFloor)
                        portalsToSearch = portalsToSearch.filter {$0.buildingID != portal.buildingID}
                        found = true
                        break
                    }
                }
            }
        } while (found)
        
        return floorsAtSameLevel
    }
}
