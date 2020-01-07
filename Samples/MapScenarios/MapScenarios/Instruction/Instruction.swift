//
//  Instruction.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/17/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

// MARK: - Notes
// The Instruction type is used to turn the data from a PWRouteInstruction object into something more easily digestable
// by the application. It doesn't contain any presentation logic, only logic to encapsulate the type of directions
// we want to provide to the user (and related data for each type). An object of this type can then be used
// to easily generate presentation logic by a type conforming to InstructionViewModel.

// MARK: - Definition and initialization -
struct Instruction {
    enum InstructionType {
        case straight
        case turn(direction: PWRouteInstructionDirection)
        case upcomingFloorChange(FloorChange)
        case floorChange(FloorChange)
    }
    
    let routeInstruction: PWRouteInstruction
    let instructionType: InstructionType
    
    var isLast: Bool {
        return routeInstruction.route?.routeInstructions?.last === routeInstruction
    }
    
    var isStraight: Bool {
        if case .straight = instructionType {
            return true
        }
        
        return false
    }
    
    init(for routeInstruction: PWRouteInstruction) {
        self.routeInstruction = routeInstruction
        
        if routeInstruction.direction == .floorChange {
            // Use this instruction's direction (which we now know is .floorChange) to create the directions type
            instructionType = type(of: self).instructionTypeForFloorChange(with: routeInstruction)
        } else {
            // Use the next instruction's direction (i.e. this instruction's 'turnDirection') to create the directions type
            instructionType = type(of: self).instructionType(with: routeInstruction)
        }
    }
}

// MARK: - Types -
extension Instruction {
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
private extension Instruction {
    static func instructionType(with routeInstruction: PWRouteInstruction) -> InstructionType {
        switch routeInstruction.turnDirection {
        case .straight:
            return .straight
            
        case .left, .right, .bearLeft, .bearRight:
            return .turn(direction: routeInstruction.turnDirection)
            
        case .floorChange:
            let floorChangeType = FloorChangeType(mapPoint: routeInstruction.end)
            var floorChangeDirection = FloorChangeDirection.sameFloor
            var floorName = NSLocalizedString("Unknown Floor Name", comment: "")
            
            if let next = routeInstruction.nextRouteInstruction,
                let startFloor = routeInstruction.floor(for: next.start),
                let endFloor = routeInstruction.floor(for: next.end) {
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
    
    static func instructionTypeForFloorChange(with routeInstruction: PWRouteInstruction) -> InstructionType {
        let floorChangeType = FloorChangeType(mapPoint: routeInstruction.end)
        var floorChangeDirection = FloorChangeDirection.sameFloor
        var floorName = NSLocalizedString("Unknown Floor Name", comment: "")
        
        if let startFloor = routeInstruction.floor(for: routeInstruction.start),
            let endFloor = routeInstruction.floor(for: routeInstruction.end) {
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

// MARK: - PWRouteInstruction private extension
private extension PWRouteInstruction {
    func floor(for point: PWMapPoint?) -> PWFloor? {
        guard let floorIdentifier = point?.floorID,
            let building = route?.building,
            let floor = building.floor(byId: floorIdentifier) else {
                return nil
        }
        
        return floor
    }
    
    var nextRouteInstruction: PWRouteInstruction? {
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
