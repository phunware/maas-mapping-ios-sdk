//
//  RouteInstructionCell.swift
//  Mapping-Sample
//
//  Created on 8/9/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class RouteInstructionCell: UITableViewCell {
    
    @IBOutlet weak var currentMovementImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var thenLabel: UILabel!
    @IBOutlet weak var turnImageView: UIImageView!
    @IBOutlet weak var turnLabel: UILabel!
    
    var routeAccessibilityManager: RouteAccessibilityManager!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureFor(routeInstruction: PWRouteInstruction?) {
        guard let routeInstruction = routeInstruction else {
            return
        }
        
        currentMovementImageView.image = CommonSettings.imageFromDirection(routeInstruction.movementDirection)
        turnImageView.image = CommonSettings.imageFromDirection(routeInstruction.turnDirection)
        if routeInstruction.isLastInstruction() {
            thenLabel.text = ""
            turnImageView.isHidden = true
        } else {
            thenLabel.text = NSLocalizedString("Then:", comment: "")
            turnImageView.isHidden = false
        }
        
        configureDistanceLabel(routeInstruction: routeInstruction)
        configureTurnLabel(routeInstruction: routeInstruction)
    }
    
    func configureDistanceLabel(routeInstruction: PWRouteInstruction) {
        if routeInstruction.isLastInstruction() || routeInstruction.isFloorChange() {
            distanceLabel.text = routeInstruction.movement
        } else {
            distanceLabel.text = CommonSettings.distanceString(from: routeInstruction.distance)
        }
    }
    
    func configureTurnLabel(routeInstruction: PWRouteInstruction) {
        if routeInstruction.isLastInstruction() {
            turnLabel.text = ""
        } else if routeInstruction.nextInstruction()?.isFloorChange() ?? false {
            turnLabel.text = routeInstruction.turn!
        } else {
            turnLabel.text = routeAccessibilityManager.orientationStringFor(direction: CLLocationDirection(routeInstruction.turnAngle))
        }
    }
}
