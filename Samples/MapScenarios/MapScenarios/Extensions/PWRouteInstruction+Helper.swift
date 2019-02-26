//
//  PWRouteInstruction+Helper.swift
//  MapScenarios
//
//  Created on 2/25/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

extension PWRouteInstruction {
    
    var highlightedFont: UIFont {
        return .systemFont(ofSize: 15.0, weight: .bold)
    }
    
    func attributedInstructionString(highlightedTextColor: UIColor, regularTextColor: UIColor) -> NSAttributedString {
        let attributedDirectionString = stringForTurnDirection(highlightedTextColor: highlightedTextColor, regularTextColor: regularTextColor)
        if distance > 0 {
            let attributedDistanceString = NSAttributedString(string: " \(distanceString())", attributes: [.foregroundColor: regularTextColor])
            attributedDirectionString.append(attributedDistanceString)
        }
        if route.routeInstructions.last == self {
            let attributedArrivalString = NSAttributedString(string: NSLocalizedString(" to arrive at your destination", comment: ""), attributes: [.foregroundColor: regularTextColor])
            attributedDirectionString.append(attributedArrivalString)
        }
        let attributedPeriod = isFloorChange() ? NSAttributedString(string: ".", attributes: [.foregroundColor: highlightedTextColor, .font: highlightedFont]) : NSAttributedString(string: ".", attributes: [.foregroundColor: regularTextColor])
        attributedDirectionString.append(attributedPeriod)
        return attributedDirectionString
    }
    
    func stringForTurnDirection(highlightedTextColor: UIColor, regularTextColor: UIColor) -> NSMutableAttributedString {
        let direction = isFloorChange() ? movementDirection : turnDirection
        let stringForDirection = NSMutableAttributedString(attributedString: starterStringForDirection(direction, highlightedTextColor: highlightedTextColor, regularTextColor: regularTextColor))
        if isFloorChange() || (nextInstruction()?.isFloorChange() ?? false) {
            let floorNameAttributedString = NSAttributedString(string: " \(destinationFloorName())", attributes: [.foregroundColor: highlightedTextColor, .font: highlightedFont])
            stringForDirection.append(floorNameAttributedString)
            if distance > 0 {
                let attributedSuffix = NSAttributedString(string: NSLocalizedString(" in", comment: ""), attributes: [.foregroundColor: regularTextColor])
                stringForDirection.append(attributedSuffix)
            }
        }
        return stringForDirection
    }
    
    func starterStringForDirection(_ direction: PWRouteInstructionDirection, highlightedTextColor: UIColor, regularTextColor: UIColor) -> NSAttributedString {
        var highlightedString = ""
        var regularString = ""
        switch direction {
        case .straight:
            highlightedString = NSLocalizedString("Go straight", comment: "")
            regularString = NSLocalizedString(" for", comment: "")
        case .left:
            highlightedString = NSLocalizedString("Turn left", comment: "")
            regularString = NSLocalizedString(" in", comment: "")
        case .right:
            highlightedString = NSLocalizedString("Turn right", comment: "")
            regularString = NSLocalizedString(" in", comment: "")
        case .bearLeft:
            highlightedString = NSLocalizedString("Bear left", comment: "")
            regularString = NSLocalizedString(" in", comment: "")
        case .bearRight:
            highlightedString = NSLocalizedString("Bear right", comment: "")
            regularString = NSLocalizedString(" in", comment: "")
        case .floorChange:
            highlightedString = NSLocalizedString("Floor change", comment: "")
            regularString = NSLocalizedString(" in", comment: "")
        case .elevatorUp:
            highlightedString = NSLocalizedString("Take the elevator up to", comment: "")
        case .elevatorDown:
            highlightedString = NSLocalizedString("Take the elevator down to", comment: "")
        case .stairsUp:
            highlightedString = NSLocalizedString("Take the stairs up to", comment: "")
        case .stairsDown:
            highlightedString = NSLocalizedString("Take the stairs down to", comment: "")
        case .escalatorUp:
            highlightedString = NSLocalizedString("Take the escalator up to", comment: "")
        case .escalatorDown:
            highlightedString = NSLocalizedString("Take the escalator down to", comment: "")
        }
        
        let highlightedAttributedString = NSAttributedString(string: highlightedString, attributes: [.foregroundColor: highlightedTextColor, .font: highlightedFont])
        let regularAttributedString = NSAttributedString(string: regularString, attributes: [.foregroundColor: regularTextColor])
        let finalAttributedString = NSMutableAttributedString(attributedString: highlightedAttributedString)
        finalAttributedString.append(regularAttributedString)
        return finalAttributedString
    }
    
    func isFloorChange() -> Bool {
        let floorChangeDirections = [PWRouteInstructionDirection.floorChange, .elevatorDown, .elevatorDown, .stairsUp, .stairsDown, .escalatorUp, .escalatorDown]
        return floorChangeDirections.contains(movementDirection)
    }
    
    func destinationFloorName() -> String {
        guard let route = route, let building = route.building, let indexOfInstruction = route.routeInstructions.index(of: self) else {
            return ""
        }
        
        let nextInstructionIndex = indexOfInstruction + 1
        var instructionToUse = self
        if nextInstructionIndex < route.routeInstructions.count {
            instructionToUse = route.routeInstructions[nextInstructionIndex]
        }
        
        if let lastPoint = instructionToUse.points.last, let floor = building.floor(byId: lastPoint.floorID) {
            return floor.name
        } else {
            return "Unknown floor"
        }
    }
    
    func distanceString() -> String {
        let roundedDistance = Int(round(distance))
        if roundedDistance == 1 {
            return NSLocalizedString("\(roundedDistance) meter", comment: "")
        }
        return "\(Int(round(distance))) meters"
    }
    
    func nextInstruction() -> PWRouteInstruction? {
        guard let indexOfInstruction = route.routeInstructions.index(of: self), let route = route else {
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
