//
//  Directions.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/17/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

// MARK: - Notes
// The Directions type is used to turn the data from a PWRouteInstruction object into something more
// easily digestable by the application. It doesn't contain any presentation logic, only logic
// to encapsulate the type of directions we want to provide to the user (and related data for each type).
// Presentation logic will be provided by a type confomring to DirectionsViewModel

// MARK: - Definition and initialization -
struct Directions {
    enum DirectionsType {
        case straight
        case turn(direction: PWRouteInstructionDirection)
        case upcomingFloorChange(FloorChange)
        case floorChange(FloorChange)
    }
    
    let instruction: PWRouteInstruction
    let directionsType: DirectionsType
    
    init(for instruction: PWRouteInstruction) {
        self.instruction = instruction
        
        if instruction.direction == .floorChange {
            // Use this instruction's direction (which we now know is .floorChange) to create the directions type
            directionsType = Self.floorChangeDirectionsType(with: instruction)
        } else {
            // Use the next instruction's direction (i.e. this instruction's 'turnDirection') to create the directions type
            directionsType = Self.standardDirectionsType(with: instruction)
        }
    }
    
    var isLast: Bool {
        return instruction.route?.routeInstructions?.last === instruction
    }
}

// MARK: - Types -
extension Directions {
    enum FloorChangeType {
        case stairs
        case elevator
        case escalator
        case other
        
        init(mapPoint: PWMapPoint) {
            // only PWPointOfInterest objects have a 'pointOfInterestType' property
            guard let poi = mapPoint as? PWPointOfInterest, let poiType = poi.pointOfInterestType else {
                self = .other
                return
            }
            
            switch poiType.identifier {
            case PWFloorChangePOI.stairs.rawValue:
                self = .stairs
            case PWFloorChangePOI.elevator.rawValue:
                self = .elevator
            case PWFloorChangePOI.escalator.rawValue:
                self = .escalator
            default:
                self = .other
            }
        }
    }
    
    enum FloorChangeDirection {
        case up
        case down
        case sameFloor
    }
    
    struct FloorChange {
        let floorChangeType: FloorChangeType
        let floorChangeDirection: FloorChangeDirection
        let floorName: String
    }
}

// MARK: - private implemenation -
private extension Directions {
    static func standardDirectionsType(with instruction: PWRouteInstruction) -> DirectionsType {
        switch instruction.turnDirection {
        case .straight:
            return .straight
            
        case .left, .right, .bearLeft, .bearRight:
            return .turn(direction: instruction.turnDirection)
            
        case .floorChange:
            let floorChangeType = FloorChangeType(mapPoint: instruction.end)
            var floorChangeDirection = FloorChangeDirection.sameFloor
            var floorName = NSLocalizedString("Unknown Floor Name", comment: "")
            
            if let next = instruction.getNextInstruction(),
                let startFloor = instruction.floor(for: next.start),
                let endFloor = instruction.floor(for: next.end) {
                floorName = endFloor.name
                
                if endFloor.level > startFloor.level {
                    floorChangeDirection = .up
                } else if endFloor.level < startFloor.level{
                    floorChangeDirection = .down
                }
            }
            
            let floorChange = FloorChange(floorChangeType: floorChangeType,
                                          floorChangeDirection: floorChangeDirection,
                                          floorName: floorName)
            
            return .upcomingFloorChange(floorChange)
            
        default:
            return .straight
        }
    }
    
    static func floorChangeDirectionsType(with instruction: PWRouteInstruction) -> DirectionsType {
        let floorChangeType = FloorChangeType(mapPoint: instruction.end)
        var floorChangeDirection = FloorChangeDirection.sameFloor
        var floorName = NSLocalizedString("Unknown Floor Name", comment: "")
        
        if let startFloor = instruction.floor(for: instruction.start),
            let endFloor = instruction.floor(for: instruction.end) {
            floorName = endFloor.name
            
            if endFloor.level > startFloor.level {
                floorChangeDirection = .up
            } else if endFloor.level < startFloor.level{
                floorChangeDirection = .down
            }
        }
        
        let floorChange = FloorChange(floorChangeType: floorChangeType,
                                      floorChangeDirection: floorChangeDirection,
                                      floorName: floorName)
        
        return .floorChange(floorChange)
    }
}
