//
//  StandardManeuverViewModel.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

struct StandardManeuverViewModel {
    private let maneuver: Maneuver
    private let standardOptions: ManeuverTextOptions
    private let highlightOptions: ManeuverTextOptions
    
    init(for instruction: PWRouteInstruction,
         standardOptions: ManeuverTextOptions = .defaultStandardOptions,
         highlightOptions: ManeuverTextOptions = .defaultHighlightOptions) {
        self.maneuver = Maneuver(for: instruction)
        self.standardOptions = standardOptions
        self.highlightOptions = highlightOptions
    }
}

extension StandardManeuverViewModel: ManeuverViewModel {
    var image: UIImage {
        return .image(for: maneuver)
    }
    
    var attributedText: NSAttributedString {
        let attributed = baseAttributedStringForManeuver
        
        // For the last maneuver, append a string indicating arrival.
        if maneuver.isLastManeuver {
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
    
    private var baseAttributedStringForManeuver: NSMutableAttributedString {
        switch maneuver.maneuverType {
        case .straight:
            let templateString = NSLocalizedString("$0 for $1", comment: "$0 = direction, $1 = distance")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let straightString = NSLocalizedString("Go straight", comment: "")
            attributed.replace(substring: "$0", with: straightString, attributes: highlightOptions.attributes)
            
            let distanceString = maneuver.instruction.distance.localizedStringForManeuver
            attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
            return attributed
            
        case .turn(let direction):
            let templateString = NSLocalizedString("$0 in $1", comment: "$0 = direction, $1 = distance")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let turnString: String
            
            switch direction {
            case .left:
                turnString = NSLocalizedString("Turn left", comment: "")
            case .right:
                turnString = NSLocalizedString("Turn right", comment: "")
            case .bearLeft:
                turnString = NSLocalizedString("Bear left", comment: "")
            case .bearRight:
                turnString = NSLocalizedString("Bear right", comment: "")
            default:
                // should never happen
                turnString = ""
            }
            
            attributed.replace(substring: "$0", with: turnString, attributes: highlightOptions.attributes)
            
            let distanceString = maneuver.instruction.distance.localizedStringForManeuver
            attributed.replace(substring: "$1", with: distanceString, attributes: standardOptions.attributes)
            return attributed
            
        case .upcomingFloorChange(let floorChange):
            let templateString = NSLocalizedString("Continue $0 towards $1 to $2", comment: "$0 = distance, $1 floor change type, $2 = floor name")
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let distanceString = maneuver.instruction.distance.localizedStringForManeuver
            attributed.replace(substring: "$0", with: distanceString, attributes: standardOptions.attributes)
            
            let floorChangeString: String
            
            switch floorChange.floorChangeType {
            case .stairs:
                floorChangeString = NSLocalizedString("stairs", comment: "")
            case .escalator:
                floorChangeString = NSLocalizedString("escalator", comment: "")
            case .elevator:
                floorChangeString = NSLocalizedString("elevator", comment: "")
            case .other:
                floorChangeString = NSLocalizedString("floor change", comment: "")
            }
            
            attributed.replace(substring: "$1", with: floorChangeString, attributes: highlightOptions.attributes)
            attributed.replace(substring: "$2", with: floorChange.floorName, attributes: highlightOptions.attributes)
            return attributed
            
        case .floorChange(let floorChange):
            let templateString = (floorChange.floorChangeDirection == .sameFloor)
                ? NSLocalizedString("Take the $0 to $2", comment: "$0 = floor change type, $2 = floor name")
                : NSLocalizedString("Take the $0 $1 to $2", comment: "$0 = floor change type, $1 = floor change direction, $2 = floor name")
            
            let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
            
            let floorChangeString: String
            
            switch floorChange.floorChangeType {
            case .stairs:
                floorChangeString = NSLocalizedString("stairs", comment: "")
            case .escalator:
                floorChangeString = NSLocalizedString("escalator", comment: "")
            case .elevator:
                floorChangeString = NSLocalizedString("elevator", comment: "")
            case .other:
                floorChangeString = NSLocalizedString("floor change", comment: "")
            }
            
            
            attributed.replace(substring: "$0", with: floorChangeString, attributes: highlightOptions.attributes)
            
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
}
