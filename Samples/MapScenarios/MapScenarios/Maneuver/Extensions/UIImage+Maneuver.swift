//
//  UIImage+Maneuver.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func image(for maneuver: Maneuver) -> UIImage {
        switch maneuver.maneuverType {
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
            return imageForFloorChangeManeuver(floorChangeType: floorChange.floorChangeType,
                                               floorChangeDirection: floorChange.floorChangeDirection)
        }
    }
    
    private static func imageForFloorChangeManeuver(floorChangeType: Maneuver.FloorChangeType,
                                                    floorChangeDirection: Maneuver.FloorChangeDirection) -> UIImage {
        // if we get here, we're looking for floor change icons
         switch floorChangeType {
         case .stairs:
             switch floorChangeDirection {
             case .up:
                 return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsUp")
             case .down:
                 return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsDown")
             case .sameFloor:
                 break
             }
         case .elevator:
             switch floorChangeDirection {
             case .up:
                 return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorUp")
             case .down:
                 return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorDown")
             case .sameFloor:
                 break
             }
         case .escalator:
             switch floorChangeDirection {
             case .up:
                 return #imageLiteral(resourceName: "PWRouteInstructionDirectionEscalatorDown")
             case .down:
                 return #imageLiteral(resourceName: "PWRouteInstructionDirectionEscalatorUp")
             case .sameFloor:
                 break
             }
         case .other:
             break
         }
         
         return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
    }
}
