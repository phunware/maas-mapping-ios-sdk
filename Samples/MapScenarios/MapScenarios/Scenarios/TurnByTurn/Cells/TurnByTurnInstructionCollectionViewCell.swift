//
//  TurnByTurnInstructionCollectionViewCell.swift
//  MapScenarios
//
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

class TurnByTurnInstructionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var movementLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    @IBOutlet weak var turnImage: UIImageView!
    @IBOutlet weak var turnLabel: UILabel!
    
    var routeInstruction: PWRouteInstruction? {
        didSet {
            guard let routeInstruction = routeInstruction, let indexOfRouteInstruction = routeInstruction.route.routeInstructions.index(of: routeInstruction) else {
                return
            }
            
            movementImage.image = imageFromDirection(routeInstruction.movementDirection)
            movementLabel.text = routeInstruction.movement
            
            let routeInstructionCount = routeInstruction.route.routeInstructions.count
            if indexOfRouteInstruction == routeInstructionCount - 1 {
                nextLabel.text = nil
                turnImage.image = nil
                turnLabel.text = nil
            } else {
                nextLabel.text = NSLocalizedString("Next: ", comment: "")
                turnImage.image = imageFromDirection(routeInstruction.turnDirection)
                turnLabel.text = routeInstruction.turn
            }            
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
    }
    
    private func imageFromDirection(_ direction: PWRouteInstructionDirection) -> UIImage {
        switch direction {
        case .straight:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
        case .left:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionSharpLeft")
        case .right:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionSharpRight")
        case .bearLeft:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionBearLeft")
        case .bearRight:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionBearRight")
        case .elevatorUp:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorUp")
        case .elevatorDown:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorDown")
        case .stairsUp:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsUp")
        case .stairsDown:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsDown")
        default:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
        }
    }
}
