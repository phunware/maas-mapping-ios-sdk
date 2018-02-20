//
//  RouteAccessibilityManager.swift
//  Mapping-Sample
//
//  Created on 8/11/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import CoreLocation
import PWMapKit

protocol RouteAccessibilityManagerDelegate {
    func routeInstruction(_ routeInstruction: PWRouteInstruction, didChangeOrientation accessibilityString: String, orientationIsCorrect: Bool)
}

enum DirectionType {
    case general
    case clock
}

class RouteAccessibilityManager: NSObject {
    
    var currentHeading: CLHeading?
    var currentInstruction: PWRouteInstruction?
    var directionType = DirectionType.clock
    var delegate: RouteAccessibilityManagerDelegate?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(headingUpdated(notification:)), name: .headingUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(routeInstructionUpdated(notification:)), name: NSNotification.Name(rawValue: PWRouteInstructionChangedNotificationKey), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func headingUpdated(notification: Notification) {
        guard let heading = notification.object as? CLHeading, let currentInstruction = currentInstruction else {
            return
        }
        
        currentHeading = heading
        
        let angleBetweenHeadingAndInstruction = currentInstruction.turnAngleToFaceHeadingFrom(currentBearing: heading.trueHeading)
        let accessibilityString = orientationStringFor(direction: angleBetweenHeadingAndInstruction)
        let isCorrectOrientation = clockDirectionFrom(angle: angleBetweenHeadingAndInstruction) == 12
        delegate?.routeInstruction(currentInstruction, didChangeOrientation: accessibilityString, orientationIsCorrect: isCorrectOrientation)
    }
    
    func routeInstructionUpdated(notification: Notification) {
        guard let routeInstruction = notification.object as? PWRouteInstruction else {
            return
        }
        
        currentInstruction = routeInstruction
    }
    
    func orientationStringFor(direction: CLLocationDirection) -> String {
        switch directionType {
        case .general:
            if abs(direction) > 45 {
                if direction > 0 {
                    return NSLocalizedString("Turn right", comment: "")
                } else {
                    return NSLocalizedString("Turn left", comment: "")
                }
            } else if abs(direction) > 22.5 {
                if direction > 0 {
                    return NSLocalizedString("Bear right", comment: "")
                } else {
                    return NSLocalizedString("Bear left", comment: "")
                }
            } else {
                return NSLocalizedString("Go straight", comment: "")
            }
        case .clock:
            let clockDirection = clockDirectionFrom(angle: direction)
            let localizedFormattedString = NSLocalizedString("Turn to your %i o'clock", comment: "")
            return String(format: localizedFormattedString, clockDirection)
        }
    }
    
    func clockDirectionFrom(angle: CLLocationDirection) -> Int {
        var clockDirection = 12
        
        switch angle {
        case -165..<(-135):
            clockDirection = 7
        case -135..<(-105):
            clockDirection = 8
        case -105..<(-75):
            clockDirection = 9
        case -75..<(-35):
            clockDirection = 10
        case -35..<(-15):
            clockDirection = 11
        case -15..<(15):
            clockDirection = 12
        case 15..<(35):
            clockDirection = 1
        case 35..<(75):
            clockDirection = 2
        case 75..<(105):
            clockDirection = 3
        case 105..<(135):
            clockDirection = 4
        case 135..<(165):
            clockDirection = 5
        default:
            clockDirection = 6
        }
        
        return clockDirection
    }
}
