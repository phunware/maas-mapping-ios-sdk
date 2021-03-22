//
//  RouteHeaderView.swift
//  LocationDiagnosticSwift
//
//  Created by Patrick Dunshee on 8/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import PWMapKit

class RouteHeaderView: UIView {
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var accessibilityButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }
    
    func configureFor(mapView: PWMapView, textFieldDelegate: UITextFieldDelegate, accessibilityButtonSelector: Selector, swapButtonSelector: Selector, routeButtonSelector: Selector, selectorTarget: Any) {
        startTextField.delegate = textFieldDelegate
        endTextField.delegate = textFieldDelegate
        accessibilityButton.addTarget(selectorTarget, action: accessibilityButtonSelector, for: .touchUpInside)
        swapButton.addTarget(selectorTarget, action: swapButtonSelector, for: .touchUpInside)
        routeButton.addTarget(selectorTarget, action: routeButtonSelector, for: .touchUpInside)
        
        configureTextFields()
        swapButton.accessibilityHint = NSLocalizedString("Tap to reverse start point and end point", comment: "")
        configureAccessibilityButton()
        configureRouteButton()
        
        accessibilityElements?.removeAll()
    
    }
    
    func configureTextFields() {
        let startLabel = UILabel()
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.text = NSLocalizedString(" Start:", comment: "")
        startLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        startLabel.textColor = .lightGray
        startLabel.isAccessibilityElement = false
        startTextField.leftViewMode = .always
        startTextField.leftView = startLabel
        startTextField.placeholder = NSLocalizedString("Search for start Point of Interest", comment: "")
        
        let endLabel = UILabel()
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.text = NSLocalizedString(" End:", comment: "")
        endLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        endLabel.textColor = .lightGray
        endLabel.isAccessibilityElement = false
        endTextField.leftViewMode = .always
        endTextField.leftView = endLabel
        endTextField.placeholder = NSLocalizedString("Search for end Point of Interest", comment: "")
    }
    
    func configureAccessibilityButton() {
        accessibilityButton.imageView?.tintColor = .darkGray
        accessibilityButton.accessibilityHint = NSLocalizedString("Tap to enable wheelchair accessible route", comment: "")
    }
    
    func configureRouteButton() {
        routeButton.setTitle(NSLocalizedString("Route", comment: ""), for: .normal)
        routeButton.layer.borderColor = UIColor.lightGray.cgColor
        routeButton.layer.borderWidth = 1
        routeButton.layer.cornerRadius = 7
        routeButton.clipsToBounds = true
        routeButton.accessibilityHint = NSLocalizedString("Tap to start route", comment: "")
        setRouteButtonActive(false)
    }
        
    func setRouteButtonActive(_ active: Bool) {
        if active {
            routeButton.setTitleColor(.white, for: .normal)
            routeButton.backgroundColor = tintColor
            routeButton.isUserInteractionEnabled = true
        } else {
            routeButton.setTitleColor(.white, for: .normal)
            routeButton.backgroundColor = .lightGray
            routeButton.isUserInteractionEnabled = false
        }
    }
}
