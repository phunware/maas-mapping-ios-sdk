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
    @IBOutlet weak var expandButton: UIButton!
    
    var buttonAction: (() -> Void)?
    
    private var shadowLayer: CAShapeLayer?
    private let cornerRadius: CGFloat = 10
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        clipsToBounds = false
        containerView.layer.cornerRadius = cornerRadius
        containerView.clipsToBounds = true
        
        let templateExpandImage = expandButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        expandButton.setImage(templateExpandImage, for: .normal)
        expandButton.imageView?.tintColor = .gray
        
        contentView.isUserInteractionEnabled = false
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
    
    @IBAction func expandButtonTapped(_ sender: UIButton) {
        buttonAction?()
    }
    
    func configure(with viewModel: ManeuverViewModel) {
        movementImage.image = viewModel.image
        movementLabel.attributedText = viewModel.attributedText
    }
}
