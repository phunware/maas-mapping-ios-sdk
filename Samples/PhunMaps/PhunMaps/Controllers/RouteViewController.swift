//
//  RouteViewController.swift
//  Mapping-Sample
//
//  Created on 8/14/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class RouteViewController: UIViewController, POISearchable {
    
    let currentLocationText = NSLocalizedString("Current Location", comment: "")
    let droppedPinText = NSLocalizedString("Dropped Pin", comment: "")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routeHeaderView: RouteHeaderView!
    
    var filteredPOIs: [PWPointOfInterest]!
    var sectionedPOIs: [String : [PWPointOfInterest]]!
    var sortedSectionedPOIKeys: [String]!
    
    var mapView: PWMapView!
    
    var startPointOfInterest: PWPointOfInterest?
    var endPointOfInterest: PWPointOfInterest?
    
    var pointsToExclude: [PWPointOfInterest]? {
        get {
            if startPointOfInterest == nil && endPointOfInterest == nil {
                return nil
            }
            var points = [PWPointOfInterest]()
            if let startPoint = startPointOfInterest {
                points.append(startPoint)
            }
            if let endPoint = endPointOfInterest {
                points.append(endPoint)
            }
            return points
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Direction", comment: "")
        
        navigationController?.navigationBar.barTintColor = CommonSettings.navigationBarBackgroundColor
        navigationController?.navigationBar.tintColor = CommonSettings.navigationBarForegroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : CommonSettings.viewForegroundColor]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close(barButtonItem:)))
        
        tableView.register(UINib(nibName: String(describing: POITableViewCell.self), bundle: nil), forCellReuseIdentifier: POICellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        filteredPOIs = [PWPointOfInterest]()
        sectionedPOIs = [String : [PWPointOfInterest]]()
        sortedSectionedPOIKeys = [String]()
        
        routeHeaderView.configureFor(mapView: mapView, textFieldDelegate: self, accessibilityButtonSelector: #selector(accessibilityTapped), swapButtonSelector: #selector(swapTapped), routeButtonSelector: #selector(routeTapped), currentLocationButtonSelector: #selector(currentLocationTapped), droppedPinButtonSelector: #selector(droppedPinTapped), selectorTarget: self)
        
        search(keyword: nil, pointsToExclude: pointsToExclude)
        
        routeHeaderView.startTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func close(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func preRouteCheck() {
        guard let startText = routeHeaderView.startTextField.text, let endText = routeHeaderView.endTextField.text else {
            setRouteButton(active: false)
            return
        }
        
        if let startPoint = startPointOfInterest, let endPoint = endPointOfInterest {
            if startPoint.identifier == endPoint.identifier {
                if routeHeaderView.startTextField.isEditing {
                    routeHeaderView.startTextField.text = nil
                    startPointOfInterest = nil
                } else {
                    routeHeaderView.endTextField.text = nil
                    endPointOfInterest = nil
                }
            }
        }
        
        if startText.characters.count > 0 && endText.characters.count > 0 {
            setRouteButton(active: true)
        } else {
            setRouteButton(active: false)
        }
    }
    
    func setRouteButton(active: Bool) {
        if active {
            routeHeaderView.routeButton.setTitleColor(.white, for: .normal)
            routeHeaderView.routeButton.backgroundColor = CommonSettings.toolbarColor
            routeHeaderView.routeButton.isUserInteractionEnabled = true
        } else {
            routeHeaderView.routeButton.setTitleColor(CommonSettings.toolbarColor, for: .normal)
            routeHeaderView.routeButton.backgroundColor = .white
            routeHeaderView.routeButton.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UITableViewDelegate

extension RouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedSectionedPOIKeys
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pois = sectionedPOIs[sortedSectionedPOIKeys[indexPath.section]] else {
            return
        }
        let pointOfInterest = pois[indexPath.row]
        
        if routeHeaderView.startTextField.isEditing {
            routeHeaderView.startTextField.text = pointOfInterest.title
            startPointOfInterest = pointOfInterest
            routeHeaderView.endTextField.becomeFirstResponder()
        } else {
            routeHeaderView.endTextField.text = pointOfInterest.title
            endPointOfInterest = pointOfInterest
            routeHeaderView.startTextField.becomeFirstResponder()
        }
        
        preRouteCheck()
    }
}

// MARK: - UITableViewDataSource

extension RouteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedPOIs.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[section]] {
            return pois.count
        }
        
        return sectionedPOIs.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POICellIdentifier, for: indexPath) as! POITableViewCell
        
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[indexPath.section]] {
            let poi = pois[indexPath.row]
            cell.setPointOfInterest(poi: poi)
        }
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension RouteViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        search(keyword: textField.text, pointsToExclude: pointsToExclude)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == routeHeaderView.startTextField {
            startPointOfInterest = nil
        } else if textField == routeHeaderView.endTextField {
            endPointOfInterest = nil
        }
        if range.length > 0 {
            if let text = textField.text as NSString? {
                search(keyword: text.substring(to: range.location), pointsToExclude: pointsToExclude)
            }
        } else {
            search(keyword: textField.text?.appending(string), pointsToExclude: pointsToExclude)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == routeHeaderView.startTextField {
            startPointOfInterest = nil
        } else if textField == routeHeaderView.endTextField {
            endPointOfInterest = nil
        }
        search(keyword: nil, pointsToExclude: pointsToExclude)
        return true
    }
}

// MARK: - UI Actions

extension RouteViewController {
    
    func accessibilityTapped() {
        if routeHeaderView.accessibilityButton.alpha == 1.0 {
            routeHeaderView.accessibilityButton.accessibilityHint = NSLocalizedString("Tap to enable wheelchair accessible route", comment: "")
            routeHeaderView.accessibilityButton.isSelected = false
            routeHeaderView.accessibilityButton.alpha = 0.2
        } else {
            routeHeaderView.accessibilityButton.accessibilityHint = NSLocalizedString("Tap to disable wheelchair accessible route", comment: "")
            routeHeaderView.accessibilityButton.isSelected = true
            routeHeaderView.accessibilityButton.alpha = 1.0
        }
    }
    
    func swapTapped() {
        routeHeaderView.startTextField.text = endPointOfInterest?.title ?? ""
        routeHeaderView.endTextField.text = startPointOfInterest?.title ?? ""
        
        let startPointCopy = startPointOfInterest
        startPointOfInterest = endPointOfInterest
        endPointOfInterest = startPointCopy
    }
    
    func routeTapped() {
        if routeHeaderView.startTextField.isEditing {
            routeHeaderView.startTextField.resignFirstResponder()
        } else if routeHeaderView.endTextField.isEditing {
            routeHeaderView.endTextField.resignFirstResponder()
        }
        
        var startPoint: PWMapPoint? = startPointOfInterest
        if startPoint == nil, let startText = routeHeaderView.startTextField.text {
            if startText == droppedPinText {
                startPoint = mapView.customLocation
            } else if startText == currentLocationText {
                startPoint = mapView.userLocation
            }
        }
        var endPoint: PWMapPoint? = endPointOfInterest
        if endPoint == nil, let endText = routeHeaderView.endTextField.text {
            if endText == droppedPinText {
                endPoint = mapView.customLocation
            } else if endText == currentLocationText {
                endPoint = mapView.userLocation
            }
        }
        
        if let startPoint = startPoint, let endPoint = endPoint {
            PWRoute.createRoute(from: startPoint, to: endPoint, accessibility: routeHeaderView.accessibilityButton.isSelected, excludedPoints: nil, completion: { [weak self] (route, error) in
                DispatchQueue.main.async {
                    if let route = route {
                        self?.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: .startNavigatingRoute, object: route)
                    } else {
                        self?.routeNotFound()
                    }
                }
            })
        } else {
            routeNotFound()
        }
    }
    
    func routeNotFound() {
        DispatchQueue.main.async {
            let routeNotFoundAlert = UIAlertController(title: nil, message: NSLocalizedString("The route couldn't be found", comment: ""), preferredStyle: .alert)
            let okayAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: nil)
            routeNotFoundAlert.addAction(okayAction)
            self.present(routeNotFoundAlert, animated: true, completion: nil)
        }
    }
    
    func currentLocationTapped() {
        if routeHeaderView.endTextField.isEditing {
            routeHeaderView.endTextField.text = currentLocationText
            routeHeaderView.startTextField.becomeFirstResponder()
        } else {
            routeHeaderView.startTextField.text = currentLocationText
            routeHeaderView.endTextField.becomeFirstResponder()
        }
        
        preRouteCheck()
    }
    
    func droppedPinTapped() {
        if routeHeaderView.endTextField.isEditing {
            routeHeaderView.endTextField.text = droppedPinText
            routeHeaderView.startTextField.becomeFirstResponder()
        } else {
            routeHeaderView.startTextField.text = droppedPinText
            routeHeaderView.endTextField.becomeFirstResponder()
        }
        
        preRouteCheck()
    }
}

// MARK: - Keyboard Adjustments

extension RouteViewController {
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
