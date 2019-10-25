//
//  LandmarkDirectionsViewModel.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import PWMapKit

// MARK: - Notes
// LandmarkDirectionsViewModel contains presentation logic for route instructions generated using the
// landmark routing feature. Straight/Turn instructions may contain one or more landmarks (though we're usually
// only interested in the last one). If a landmark is found, we can provide more detailed instructions
// (such as "Turn right in 10 feet at the Water Cooler").

struct LandmarkDirectionsViewModel {
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

extension LandmarkDirectionsViewModel: DirectionsViewModel {
    var image: UIImage {
        return .image(for: directions)
    }
    
    var attributedText: NSAttributedString {
        let attributed = baseAttributedStringForDirections
        
        // For the last directions, append a string indicating arrival.
        if directions.isLast {
            let arrivalString = " " + NSLocalizedString("to arrive at your destination", comment: "")
            let attributedArrivalString = NSAttributedString(string: arrivalString, attributes: standardOptions.attributes)
            attributed.append(attributedArrivalString)
        }
        
        // Place a period at the end, using the same attributes as the last attributed substring.
        if let lastAttributes = attributed.lastAttributes {
            let period = NSAttributedString(string: ".", attributes: lastAttributes)
            attributed.append(period)
        }
        
        // we're done!
        return attributed
    }
    
    private var baseAttributedStringForDirections: NSMutableAttributedString {
        switch directions.directionsType {
        case .straight:
            if let landmark = directions.instruction.landmarks?.last {
                let templateString = NSLocalizedString("$0 for $1 towards $2", comment: "$0 = direction, $1 = distance, $2 = landmark")
                let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
                
                let straightString = NSLocalizedString("Go straight", comment: "")
                attributed.replace(substring: "$0", with: straightString, attributes: highlightOptions.attributes)
                
                let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
                attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
                
                attributed.replace(substring: "$2", with: landmark.name, attributes: highlightOptions.attributes)
                
                return attributed
            } else {
                let templateString = NSLocalizedString("$0 for $1", comment: "$0 = direction, $1 = distance")
                let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
                
                let straightString = NSLocalizedString("Go straight", comment: "")
                attributed.replace(substring: "$0", with: straightString, attributes: highlightOptions.attributes)
                
                let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
                attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
                
                return attributed
            }
            
        case .turn(let direction):
            if let landmark = directions.instruction.landmarks?.last {
                let templateString = NSLocalizedString("$0 in $1 $2 $3", comment: "$0 = direction, $1 = distance, $2 = at/after, $3 = landmark name")
                
                let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
                
                let turnString = string(for: direction) ?? ""
                attributed.replace(substring: "$0", with: turnString, attributes: highlightOptions.attributes)
                
                let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
                attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
                
                let positionString = (landmark.position == .at)
                    ? NSLocalizedString("at", comment: "")
                    : NSLocalizedString("after", comment: "")
                
                attributed.replace(substring: "$2", with: positionString, attributes: standardOptions.attributes)
                attributed.replace(substring: "$3", with: landmark.name, attributes: highlightOptions.attributes)
                
                return attributed
                
            } else {
                let templateString = NSLocalizedString("$0 in $1", comment: "$0 = direction, $1 = distance")
                let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
                
                let turnString = string(for: direction) ?? ""
                attributed.replace(substring: "$0", with: turnString, attributes: highlightOptions.attributes)
                
                let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
                attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
                return attributed
            }
            
        case .upcomingFloorChange(let floorChange):
            let templateString = NSLocalizedString("Continue $0 towards $1 to $2", comment: "$0 = distance, $1 floor change type, $2 = floor name")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let distanceString = directions.instruction.distance.localizedDistanceInSmallUnits
            attributed.replace(substring: "$0", with: distanceString, attributes: standardOptions.attributes)
            
            let floorChangeTypeString = string(for: floorChange.floorChangeType)
            attributed.replace(substring: "$1", with: floorChangeTypeString, attributes: highlightOptions.attributes)
            attributed.replace(substring: "$2", with: floorChange.floorName, attributes: highlightOptions.attributes)
            return attributed
            
        case .floorChange(let floorChange):
            let templateString = (floorChange.floorChangeDirection == .sameFloor)
                ? NSLocalizedString("Take the $0 to $2", comment: "$0 = floor change type, $2 = floor name")
                : NSLocalizedString("Take the $0 $1 to $2", comment: "$0 = floor change type, $1 = floor change direction, $2 = floor name")
            
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let floorChangeTypeString = string(for: floorChange.floorChangeType)
            attributed.replace(substring: "$0", with: floorChangeTypeString, attributes: highlightOptions.attributes)
            
            let directionString: String
            
            switch floorChange.floorChangeDirection {
            case .up:
                directionString = NSLocalizedString("up", comment: "")
            case .down:
                directionString = NSLocalizedString("down", comment: "")
            case .sameFloor:
                directionString = ""
            }
            
            attributed.replace(substring: "$1", with: directionString, attributes: standardOptions.attributes)
            attributed.replace(substring: "$2", with: floorChange.floorName, attributes: highlightOptions.attributes)
            return attributed
        }
    }
    
    private func string(for direction: PWRouteInstructionDirection) -> String? {
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
    
    private func string(for floorChangeType: Directions.FloorChangeType) -> String {
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
}
