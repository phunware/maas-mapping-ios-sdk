//
//  RouteInstructionListCell.swift
//  MapScenarios
//
//  Created on 2/27/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

class RouteInstructionListCell: UITableViewCell {
    
    @IBOutlet weak var instructionImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    func configureWithRouteInstruction(_ routeInstruction: PWRouteInstruction) {
        instructionImageView.image = routeInstruction.imageFromDirection()
        instructionLabel.attributedText = routeInstruction.attributedInstructionString(highlightedTextColor: .nasa, regularTextColor: .darkText)
    }
}
