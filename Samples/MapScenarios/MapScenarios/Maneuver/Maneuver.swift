//
//  Maneuver.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/17/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

// MARK: - Definition and initialization -
struct Maneuver {
    enum ManeuverType {
        case straight
        case turn(direction: PWRouteInstructionDirection)
        case upcomingFloorChange(UpcomingFloorChange)
        case floorChange(FloorChange)
    }
    
    let instruction: PWRouteInstruction
    let maneuverType: ManeuverType
    
    init(for instruction: PWRouteInstruction) {
        self.instruction = instruction
        
        if instruction.direction == .floorChange {
            maneuverType = type(of: self).floorChangeManeuverType(with: instruction)
        } else {
            maneuverType = type(of: self).standardManeuverType(with: instruction)
        }
    }
    
    var isLastManeuver: Bool {
        return instruction.route?.routeInstructions?.last === instruction
    }
}

// MARK: - Types -
extension Maneuver {
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
    
    struct UpcomingFloorChange {
        let floorChangeType: FloorChangeType
        let floorChangeDirection: FloorChangeDirection
        let floorName: String
    }
    
    struct FloorChange {
        let floorChangeType: FloorChangeType
        let floorChangeDirection: FloorChangeDirection
        let floorName: String
    }
}

// MARK: - private implemenation -
private extension Maneuver {
    static func standardManeuverType(with instruction: PWRouteInstruction) -> ManeuverType {
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
            
            let floorChange = UpcomingFloorChange(floorChangeType: floorChangeType,
                                                  floorChangeDirection: floorChangeDirection,
                                                  floorName: floorName)
            
            return .upcomingFloorChange(floorChange)
            
        default:
            return .straight
        }
    }
    
    static func floorChangeManeuverType(with instruction: PWRouteInstruction) -> ManeuverType {
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
