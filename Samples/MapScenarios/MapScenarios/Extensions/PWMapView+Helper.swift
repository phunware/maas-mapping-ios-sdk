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
        guard let route = currentRoute,
              let routeInstructions = currentRoute?.routeInstructions,
              let currentInstruction = currentRouteInstruction(),
              var instructionIndex = routeInstructions.firstIndex(of: currentInstruction) else {
            return nil
        }
        // Use user location for current route instruction index if possible
        if let userLocation = indoorUserLocation, let closestInstruction = route.closestInstructionTo(userLocation), let closestInstructionIndex = routeInstructions.firstIndex(of: closestInstruction) {
            instructionIndex = closestInstructionIndex
        }
        
        var distanceTotal = 0.0
        var numberOfFloorSwitchInstructions = 0.0 // Add distance to account for floor switch time
        for i in instructionIndex..<routeInstructions.count {
            let instruction = routeInstructions[i]
            if instruction.direction == .floorChange {
                numberOfFloorSwitchInstructions += 1.0
            } else {
                distanceTotal = distanceTotal + instruction.distance
            }
        }
        return route.distance + numberOfFloorSwitchInstructions * 15.0
    }
    
    func pois() -> [PWPointOfInterest]? {
        // If MapView is initialized with campus, then use campus, otherwise use building
        return (self.campus != nil) ? self.campus.pois : self.building.pois
    }
    
    func zoomToFitFloor(_ floor: PWFloor) {
        let topLeft = floor.topLeft
        let bottomRight = floor.bottomRight
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeft.latitude - (topLeft.latitude - bottomRight.latitude) * 0.5
        region.center.longitude = topLeft.longitude + (bottomRight.longitude - topLeft.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeft.latitude - bottomRight.latitude)
        region.span.longitudeDelta = fabs(bottomRight.longitude - topLeft.longitude)

        region = regionThatFits(region)
        setRegion(region, animated: true)
    }
}
