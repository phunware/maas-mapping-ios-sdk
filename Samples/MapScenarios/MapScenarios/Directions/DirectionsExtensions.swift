//
//  DirectionsExtensions.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/25/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

// MARK: - PWRouteInstruction extension
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

// MARK: - UIImage extension
extension UIImage {
    static func image(for directions: Directions) -> UIImage {
        switch directions.directionsType {
        case .straight, .upcomingFloorChange:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
            
        case .turn(let direction):
            switch direction {
            case .left:
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionSharpLeft")
            case .right:
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionSharpRight")
            case .bearLeft:
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionBearLeft")
            case .bearRight:
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionBearRight")
            default:
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
            }
            
        case .floorChange(let floorChange):
            switch (floorChange.floorChangeType, floorChange.floorChangeDirection) {
            case (.stairs, .up):
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsUp")
            case (.stairs, .down):
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsDown")
            case (.elevator, .up):
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorUp")
            case (.elevator, .down):
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorDown")
            case (.escalator, .up):
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionEscalatorDown")
            case (.escalator, .down):
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionEscalatorUp")
            default:
                return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
            }
        }
    }
}

