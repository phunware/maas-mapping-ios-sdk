//
//  PreRouteInstructionCell.swift
//  Mapping-Sample
//
//  Created on 6/20/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class PreRouteInstructionCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var movementLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(forInstruction routeInstruction: PWRouteInstruction) {
        if routeInstruction.isFloorChange() || routeInstruction.isLastInstruction() {
            distanceLabel.text = routeInstruction.movement
        } else {
            distanceLabel.text = CommonSettings.distanceString(from: routeInstruction.distance)
        }
        
        if routeInstruction.isLastInstruction() {
            movementLabel.text = ""
            accessibilityLabel = distanceLabel.text
        } else {
            movementLabel.text = routeInstruction.turn
            if let distanceLabelText = distanceLabel.text {
                var accessibilityString = String(format: NSLocalizedString("Go straight for %@", comment: ""), distanceLabelText)
                if let movementLabelText = movementLabel.text {
                    accessibilityString = "\(accessibilityString) \(movementLabelText)"
                }
                accessibilityLabel = accessibilityString
            }
        }
    }
}
