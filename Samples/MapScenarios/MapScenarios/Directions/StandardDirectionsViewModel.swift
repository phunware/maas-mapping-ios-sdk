//
//  StandardDirectionsViewModel.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

// MARK: - Notes
// StandardDirectionsViewModel contains presentation logic for basic route instructions.

struct StandardDirectionsViewModel {
    private let directions: Directions
    private let standardOptions: DirectionsTextOptions
    private let highlightOptions: DirectionsTextOptions
    
    init(for instruction: PWRouteInstruction,
         standardOptions: DirectionsTextOptions = .defaultStandardOptions,
         highlightOptions: DirectionsTextOptions = .defaultHighlightOptions) {
        self.directions = Directions(for: instruction)
        self.standardOptions = standardOptions
        self.highlightOptions = highlightOptions
    }
}

extension StandardDirectionsViewModel: DirectionsViewModel {
    var image: UIImage {
        return .image(for: directions)
    }
    
    var attributedText: NSAttributedString {
        let straightString = NSLocalizedString("Continue straight", comment: "")
        
        switch directions.directionsType {
        case .straight:
            let templateString = NSLocalizedString("$0 for $1", comment: "$0 = Continue straight, $1 = distance")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            attributed.replace(substring: "$0", with: straightString, attributes: highlightOptions.attributes)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
            
            return attributed
            
        case .turn(let direction):
            let templateString = NSLocalizedString("$0 in $1", comment: "$0 = direction, $1 = distance")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let turnString = string(forTurn: direction) ?? ""
            attributed.replace(substring: "$0", with: turnString, attributes: highlightOptions.attributes)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
            
            return attributed
            
        case .upcomingFloorChange(let floorChange):
            let templateString = NSLocalizedString("$0 $1 towards $2 to $3", comment: "$0 = Continue straight, $1 = distance, $2 floor change type, $3 = floor name")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            attributed.replace(substring: "$0", with: straightString, attributes: highlightOptions.attributes)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
            
            let floorChangeTypeString = string(for: floorChange.floorChangeType)
            attributed.replace(substring: "$2", with: floorChangeTypeString, attributes: highlightOptions.attributes)
            attributed.replace(substring: "$3", with: floorChange.floorName, attributes: highlightOptions.attributes)
            
            return attributed
            
        case .floorChange(let floorChange):
            let templateString = (floorChange.floorChangeDirection == .sameFloor)
                ? NSLocalizedString("Take the $0 to $2", comment: "$0 = floor change type, $2 = floor name")
                : NSLocalizedString("Take the $0 $1 to $2", comment: "$0 = floor change type, $1 = floor change direction, $2 = floor name")
            
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let floorChangeTypeString = string(for: floorChange.floorChangeType)
            attributed.replace(substring: "$0", with: floorChangeTypeString, attributes: highlightOptions.attributes)
            
            let directionString = string(forFloorChangeDirection: floorChange.floorChangeDirection) ?? ""
            attributed.replace(substring: "$1", with: directionString, attributes: standardOptions.attributes)
            attributed.replace(substring: "$2", with: floorChange.floorName, attributes: highlightOptions.attributes)
            
            return attributed
        }
    }
    
    var voicePrompt: String {
        var prompt = baseStringForVoicePrompt
        
        // For the last directions, append a string indicating arrival.
        if directions.isLast {
            let arrivalString = " " + NSLocalizedString("to arrive at your destination", comment: "")
            prompt = prompt + arrivalString
        }
        
        // we're done!
        return prompt
    }
}

// MARK: - private
private extension StandardDirectionsViewModel {
    var baseStringForVoicePrompt: String {
        let straightString = NSLocalizedString("Continue straight", comment: "")
        
        switch directions.directionsType {
        case .straight:
            let templateString = NSLocalizedString("$0 for $1", comment: "$0 = Continue straight, $1 = distance")
            var prompt = templateString
            
            prompt = prompt.replacingOccurrences(of: "$0", with: straightString)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            prompt = prompt.replacingOccurrences(of: "$1", with: distanceString)
            
            return prompt
            
        case .turn(let direction):
            let templateString = NSLocalizedString("$0 for $1, then $2", comment: "$0 = Continue straight, $1 = distance, $2 = direction")
            var prompt = templateString
            
            prompt = prompt.replacingOccurrences(of: "$0", with: straightString)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            prompt = prompt.replacingOccurrences(of: "$1", with: distanceString)
            
            let turnString = string(forTurn: direction)?.lowercased() ?? ""
            prompt = prompt.replacingOccurrences(of: "$2", with: turnString)
            
            return prompt
            
        case .upcomingFloorChange(let floorChange):
            let templateString = NSLocalizedString("$0 $1 towards $2 to $3", comment: "$0 = Continue straight, $1 = distance, $2 floor change type, $3 = floor name")
            var prompt = templateString
            
            prompt = prompt.replacingOccurrences(of: "$0", with: straightString)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            prompt = prompt.replacingOccurrences(of: "$1", with: distanceString)
            
            let floorChangeTypeString = string(for: floorChange.floorChangeType)
            prompt = prompt.replacingOccurrences(of: "$2", with: floorChangeTypeString)
            prompt = prompt.replacingOccurrences(of: "$3", with: floorChange.floorName)
            
            return prompt
            
        case .floorChange(let floorChange):
            let templateString = (floorChange.floorChangeDirection == .sameFloor)
                ? NSLocalizedString("Take the $0 to $2", comment: "$0 = floor change type, $2 = floor name")
                : NSLocalizedString("Take the $0 $1 to $2", comment: "$0 = floor change type, $1 = floor change direction, $2 = floor name")
            
            var prompt = templateString
            
            let floorChangeTypeString = string(for: floorChange.floorChangeType)
            prompt = prompt.replacingOccurrences(of: "$0", with: floorChangeTypeString)
            
            let directionString = string(forFloorChangeDirection: floorChange.floorChangeDirection) ?? ""
            prompt = prompt.replacingOccurrences(of: "$1", with: directionString)
            prompt = prompt.replacingOccurrences(of: "$2", with: floorChange.floorName)
            
            return prompt
        }
    }
    
    func string(for floorChangeType: Directions.FloorChangeType) -> String {
        switch floorChangeType {
        case .stairs:
            return NSLocalizedString("stairs", comment: "")
        case .escalator:
            return  NSLocalizedString("escalator", comment: "")
        case .elevator:
            return  NSLocalizedString("elevator", comment: "")
        case .other:
            return  NSLocalizedString("floor change", comment: "")
        }
    }
    
    func string(forTurn direction: PWRouteInstructionDirection) -> String? {
        switch direction {
        case .left:
            return NSLocalizedString("Turn left", comment: "")
        case .right:
            return NSLocalizedString("Turn right", comment: "")
        case .bearLeft:
            return NSLocalizedString("Bear left", comment: "")
        case .bearRight:
            return NSLocalizedString("Bear right", comment: "")
        default:
            return nil
        }
    }
    
    func string(forFloorChangeDirection direction: Directions.FloorChangeDirection) -> String? {
        switch direction {
        case .up:
            return NSLocalizedString("up", comment: "")
        case .down:
            return NSLocalizedString("down", comment: "")
        case .sameFloor:
            return nil
        }
    }
}
