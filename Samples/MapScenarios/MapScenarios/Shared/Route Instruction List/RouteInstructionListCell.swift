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
    
    func configure(with viewModel: InstructionViewModel) {
        instructionImageView.image = viewModel.image
        instructionLabel.attributedText = viewModel.attributedText
    }
}
