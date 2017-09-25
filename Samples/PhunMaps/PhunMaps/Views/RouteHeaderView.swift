//
//  RouteHeaderView.swift
//  Mapping-Sample
//
//  Created on 8/14/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import PWMapKit

class RouteHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var accessibilityButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var droppedPinButton: UIButton!
    
    override func awakeFromNib() {
        contentView.backgroundColor = .white
    }
    
    func configureFor(mapView: PWMapView, textFieldDelegate: UITextFieldDelegate, accessibilityButtonSelector: Selector, swapButtonSelector: Selector, routeButtonSelector: Selector, currentLocationButtonSelector: Selector, droppedPinButtonSelector: Selector, selectorTarget: Any) {
        startTextField.delegate = textFieldDelegate
        endTextField.delegate = textFieldDelegate
        accessibilityButton.addTarget(selectorTarget, action: accessibilityButtonSelector, for: .touchUpInside)
        swapButton.addTarget(selectorTarget, action: swapButtonSelector, for: .touchUpInside)
        routeButton.addTarget(selectorTarget, action: routeButtonSelector, for: .touchUpInside)
        currentLocationButton.addTarget(selectorTarget, action: currentLocationButtonSelector, for: .touchUpInside)
        droppedPinButton.addTarget(selectorTarget, action: droppedPinButtonSelector, for: .touchUpInside)
        
        configureTextFields()
        swapButton.accessibilityHint = NSLocalizedString("Tap to reverse start point and end point", comment: "")
        configureAccessibilityButton()
        configureRouteButton()
        configureCurrentLocationButtonFor(mapView: mapView)
        configureDroppedPinButtonFor(mapView: mapView)
        
        accessibilityElements = [startTextField, swapButton, endTextField, accessibilityButton, routeButton, droppedPinButton, currentLocationButton]
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
        accessibilityButton.accessibilityHint = NSLocalizedString("Tap to enable wheelchair accessible route", comment: "")
        accessibilityButton.alpha = 0.2
    }
    
    func configureRouteButton() {
        routeButton.setTitle(NSLocalizedString("Route", comment: ""), for: .normal)
        routeButton.setTitleColor(CommonSettings.toolbarColor, for: .normal)
        routeButton.layer.borderColor = routeButton.titleLabel?.textColor.cgColor
        routeButton.layer.borderWidth = 1
        routeButton.layer.cornerRadius = 7
        routeButton.clipsToBounds = true
        routeButton.backgroundColor = .white
        routeButton.isUserInteractionEnabled = false
        routeButton.accessibilityHint = NSLocalizedString("Tap to start route", comment: "")
    }
    
    func configureCurrentLocationButtonFor(mapView: PWMapView) {
        currentLocationButton.setTitle(NSLocalizedString("Current Location", comment: ""), for: .normal)
        currentLocationButton.isEnabled = mapView.userLocation != nil
    }
    
    func configureDroppedPinButtonFor(mapView: PWMapView) {
        droppedPinButton.setTitle(NSLocalizedString("Dropped Pin", comment: ""), for: .normal)
        droppedPinButton.isEnabled = mapView.customLocation != nil
    }
}
