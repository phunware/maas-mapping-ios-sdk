//
//  PWMapView+Helper.swift
//  MapScenarios
//
//  Created on 2/13/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

extension PWMapView {
    
    func remainingRouteDistanceFromCurrentLocation() -> CLLocationDistance? {
        guard let route = currentRoute, let currentInstruction = currentRouteInstruction(), var instructionIndex = route.routeInstructions.firstIndex(of: currentInstruction) else {
            return nil
        }
        // Use user location for current route instruction index if possible
        if let userLocation = indoorUserLocation, let closestInstruction = route.closestInstructionTo(userLocation), let closestInstructionIndex = route.routeInstructions.firstIndex(of: closestInstruction) {
            instructionIndex = closestInstructionIndex
        }
        
        var distanceTotal = 0.0
        var numberOfFloorSwitchInstructions = 0.0 // Add distance to account for floor switch time
        for i in instructionIndex..<route.routeInstructions.count {
            let instruction = route.routeInstructions[i]
            if instruction.movementDirection == .floorChange {
                numberOfFloorSwitchInstructions += 1.0
            } else {
                distanceTotal = distanceTotal + instruction.distance
            }
        }
        return route.distance + numberOfFloorSwitchInstructions * 15.0
    }
}
