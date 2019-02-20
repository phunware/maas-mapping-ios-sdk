//
//  VoicePromptButton.swift
//  MapScenarios
//
//  Created on 2/15/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import UIKit

class VoicePromptButton: UIView {
    
    var cornerRadius: CGFloat = 15 {
        didSet {
            configureCorners(value: cornerRadius)
        }
    }
    
    var backgroundImageColor: UIColor = UIColor(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1) {
        didSet {
            configureColor(color: backgroundImageColor)
        }
    }
    
    var action: (() -> Void)?
    var buttonImage: UIImage? {
        get {
            return button.image(for: .normal)
        }
        set {
            button.setImage(newValue, for: .normal)
        }
    }
    
    private let button = UIButton()
    private var shadowLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
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
    
    private func configureView() {
        backgroundColor = .clear
        configureButton()
        configureCorners(value: cornerRadius)
        configureColor(color: backgroundImageColor)
    }
    
    private func configureButton() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func configureCorners(value: CGFloat) {
        button.layer.cornerRadius = value
    }
    
    private func configureColor(color: UIColor) {
        let image = createImage(color: color)
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.clipsToBounds = true
    }
    
    private func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    @objc
    private func buttonTapped() {
        action?()
    }
}
