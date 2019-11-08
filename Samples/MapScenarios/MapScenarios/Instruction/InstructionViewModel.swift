//
//  InstructionViewModel.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import PWMapKit

// MARK: - Notes
// InstructionViewModel is used to encapsulate the presentation of route instructions.
// It doesn't contain any application/business logic, only presentation logic for displaying
// route instructions, usually in a table view/collection view cell.

// MARK: - InstructionViewModel protocol
protocol InstructionViewModel {
    var image: UIImage { get }
    var attributedText: NSAttributedString { get }
    var voicePrompt: String { get }
}

// MARK: - default implementations
extension InstructionViewModel {
    // By default, return the attributed text, stripped of it's attributes
    var voicePrompt: String {
        return attributedText.string
    }
}

// MARK: - Useful helpers
extension InstructionViewModel {
    func string(for floorChangeType: Instruction.FloorChangeType) -> String {
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
    
    func string(forFloorChangeDirection direction: Instruction.FloorChangeDirection) -> String? {
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
