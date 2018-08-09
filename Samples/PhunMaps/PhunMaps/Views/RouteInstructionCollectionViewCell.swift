//
//  RouteInstructionCollectionViewCell.swift
//  Mapping-Sample
//
//  Created on 9/21/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

class RouteInstructionCollectionViewCell: UICollectionViewCell {
    
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
            
            movementImage.image = CommonSettings.imageFromDirection(routeInstruction.movementDirection)
            movementLabel.text = routeInstruction.movement
            
            let routeInstructionCount = routeInstruction.route.routeInstructions.count
            if indexOfRouteInstruction == routeInstructionCount - 1 {
                nextLabel.text = nil
                turnImage.image = nil
                turnLabel.text = nil
            } else {
                nextLabel.text = NSLocalizedString("Next: ", comment: "")
                turnImage.image = CommonSettings.imageFromDirection(routeInstruction.turnDirection)
                turnLabel.text = routeInstruction.turn
            }            
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear        
    }
    
}
