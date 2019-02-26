//
//  TurnByTurnInstructionCollectionViewCell.swift
//  MapScenarios
//
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

class TurnByTurnInstructionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var movementLabel: UILabel!
    
    private var shadowLayer: CAShapeLayer?
    private let cornerRadius: CGFloat = 10
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        clipsToBounds = false
        containerView.layer.cornerRadius = cornerRadius
        containerView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer?.fillColor = UIColor.black.cgColor
            
            shadowLayer?.shadowColor = UIColor.black.cgColor
            shadowLayer?.shadowPath = shadowLayer?.path
            shadowLayer?.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer?.shadowOpacity = 0.3
            shadowLayer?.shadowRadius = 3
            shadowLayer?.masksToBounds = false
            
            if let shadowLayer = shadowLayer {
                layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }
    
    func updateForRouteInstruction(_ routeInstruction: PWRouteInstruction) {
        let direction = routeInstruction.isFloorChange() ? routeInstruction.movementDirection : routeInstruction.turnDirection
        movementImage.image = imageFromDirection(direction)
        movementLabel.attributedText = routeInstruction.attributedInstructionString(highlightedTextColor: UIColor(displayP3Red: 4.0/255.0, green: 114.0/255.0, blue: 254.0/255.0, alpha: 1.0), regularTextColor: .darkText)
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
        case .escalatorUp:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionEscalatorDown")
        case .escalatorDown:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionEscalatorUp")
        case .floorChange:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
        }
    }
}
