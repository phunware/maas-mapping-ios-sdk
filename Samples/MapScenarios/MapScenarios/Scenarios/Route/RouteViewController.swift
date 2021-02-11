//
//  RouteViewController.swift
//  LocationDiagnosticSwift
//
//  Created by Patrick Dunshee on 8/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

protocol PointOfInterest {
    
    var poiTitle: String! { get }
    var poiImage: UIImage! { get }
    var poiFloor: PWFloor! { get }
    var poiBuilding: PWBuilding! { get }
    var identifier: Int { get }
}

extension PWPointOfInterest: PointOfInterest {
    
    var poiTitle: String! {
        return title
    }
    
    var poiImage: UIImage! {
        return image
    }
    
    var poiFloor: PWFloor! {
        return floor
    }
    
    var poiBuilding: PWBuilding! {
        return floor?.building
    }
}
extension PWCustomPointOfInterest: PointOfInterest {
    
    var poiTitle: String! {
        return title!
    }
    
    var poiImage: UIImage! {
        return image!
    }
    
    var poiFloor: PWFloor! {
        return floor!
    }
    
    var poiBuilding: PWBuilding! {
        return floor?.building
    }
}

protocol RouteViewDelegate {
    
    func routeSelected(_ route: PWRoute)
}

class RouteViewController: UIViewController {
    
    let currentLocationText = NSLocalizedString("Current Location", comment: "")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routeHeaderView: RouteHeaderView!
    
    var filteredPOIs: [PointOfInterest]!
    var sectionedPOIs: [String : [PointOfInterest]]!
    var sortedSectionedPOIKeys: [String]!
    var customPOIs: [PWPointOfInterest]!
    
    var startFromCurrentLocation: Bool = false
    var landmarkEnabled: Bool = false
    var mapView: PWMapView!
    var delegate: RouteViewDelegate?
    
    var startPointOfInterest: PointOfInterest?
    var endPointOfInterest: PointOfInterest?
    
    var pointsToExclude: [PointOfInterest]? {
        get {
            if startPointOfInterest == nil && endPointOfInterest == nil {
                return nil
            }
            var points = [PointOfInterest]()
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
        
        title = NSLocalizedString("Route", comment: "")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        filteredPOIs = [PWPointOfInterest]()
        sectionedPOIs = [String : [PWPointOfInterest]]()
        sortedSectionedPOIKeys = [String]()
        
        routeHeaderView.configureFor(mapView: mapView, textFieldDelegate: self, accessibilityButtonSelector: #selector(accessibilityTapped), swapButtonSelector: #selector(swapTapped), routeButtonSelector: #selector(routeTapped), selectorTarget: self)
        
        search(keyword: nil, pointsToExclude: pointsToExclude)
        
        if self.startFromCurrentLocation {
            setStartingFromCurrentLocation()
        }
        else {
            routeHeaderView.startTextField.becomeFirstResponder()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func preRouteCheck() {
        guard let startText = routeHeaderView.startTextField.text, let endText = routeHeaderView.endTextField.text else {
            routeHeaderView.setRouteButtonActive(false)
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
        
        if startText.count > 0 && endText.count > 0 {
            routeHeaderView.setRouteButtonActive(true)
        } else {
            routeHeaderView.setRouteButtonActive(false)
        }
    }
    
    func setStartingFromCurrentLocation() {
        routeHeaderView.startTextField.text = currentLocationText
        routeHeaderView.endTextField.becomeFirstResponder()
        
        preRouteCheck()
    }
}

// MARK: - UITableViewDelegate

extension RouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pois = sectionedPOIs[sortedSectionedPOIKeys[indexPath.section]] else {
            return
        }
        let pointOfInterest = pois[indexPath.row]
        
        if routeHeaderView.startTextField.isEditing {
            routeHeaderView.startTextField.text = pointOfInterest.poiTitle
            startPointOfInterest = pointOfInterest
            routeHeaderView.endTextField.becomeFirstResponder()
        } else {
            routeHeaderView.endTextField.text = pointOfInterest.poiTitle
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RoutePOITableViewCell.self), for: indexPath) as! RoutePOITableViewCell
        
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[indexPath.section]] {
            let poi = pois[indexPath.row]
            cell.setPointOfInterest(poi: poi)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[section]] {
            let poi = pois[0]
            return poi.poiBuilding.name
        }
        else {
            return nil
        }
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
        routeHeaderView.setRouteButtonActive(false)
        return true
    }
}

// MARK: - UI Actions

extension RouteViewController {
    
    @objc func accessibilityTapped() {
        if routeHeaderView.accessibilityButton.isSelected {
            routeHeaderView.accessibilityButton.imageView?.tintColor = .darkGray
            routeHeaderView.accessibilityButton.accessibilityHint = NSLocalizedString("Tap to enable wheelchair accessible route", comment: "")
            routeHeaderView.accessibilityButton.isSelected = false
        } else {
            routeHeaderView.accessibilityButton.imageView?.tintColor = view.tintColor
            routeHeaderView.accessibilityButton.accessibilityHint = NSLocalizedString("Tap to disable wheelchair accessible route", comment: "")
            routeHeaderView.accessibilityButton.isSelected = true
        }
    }
    
    @objc func swapTapped() {
        let startText = routeHeaderView.startTextField.text
        routeHeaderView.startTextField.text = routeHeaderView.endTextField.text
        routeHeaderView.endTextField.text = startText
        
        let startPointCopy = startPointOfInterest
        startPointOfInterest = endPointOfInterest
        endPointOfInterest = startPointCopy
    }
    
    @objc func routeTapped() {
        if routeHeaderView.startTextField.isEditing {
            routeHeaderView.startTextField.resignFirstResponder()
        } else if routeHeaderView.endTextField.isEditing {
            routeHeaderView.endTextField.resignFirstResponder()
        }
        
        var startPoint: PWMapPoint? = startPointOfInterest as? PWMapPoint
        if startPoint == nil, let startText = routeHeaderView.startTextField.text {
            if startText == currentLocationText {
                if mapView.indoorUserLocation == nil {
                    currentLocationNotFound()
                    return
                }
                else {
                    startPoint = mapView.indoorUserLocation
                }
            }
        }

        var endPoint: PWMapPoint? = endPointOfInterest as? PWMapPoint
        if endPoint == nil, let endText = routeHeaderView.endTextField.text {
            if endText == currentLocationText {
                if mapView.indoorUserLocation == nil {
                    currentLocationNotFound()
                    return
                }
                else {
                    endPoint = mapView.indoorUserLocation
                }
            }
        }

        if let startPoint = startPoint, let endPoint = endPoint {
            // Generate the route using the current accessibility and landmark options.
            let routeOptions = PWRouteOptions(accessibilityEnabled: routeHeaderView.accessibilityButton.isSelected,
                                              landmarksEnabled: landmarkEnabled,
                                              excludedPointIdentifiers: nil)
            PWRoute.createRoute(from: startPoint,
                                to: endPoint,
                                options: routeOptions) { [weak self] (route, error) in
                DispatchQueue.main.async {
                    if let route = route {
                        self?.navigationController?.popViewController(animated: true)
                        self?.delegate?.routeSelected(route)
                    } else {
                        self?.routeNotFound()
                    }
                }
            }
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
    
    func currentLocationNotFound() {
        DispatchQueue.main.async {
            let routeNotFoundAlert = UIAlertController(title: nil, message: NSLocalizedString("Current location is not available", comment: ""), preferredStyle: .alert)
            let okayAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: nil)
            routeNotFoundAlert.addAction(okayAction)
            self.present(routeNotFoundAlert, animated: true, completion: nil)
        }
    }

    
    @objc func currentLocationTapped() {
        if routeHeaderView.endTextField.isEditing {
            routeHeaderView.endTextField.text = currentLocationText
            routeHeaderView.startTextField.becomeFirstResponder()
        } else {
            routeHeaderView.startTextField.text = currentLocationText
            routeHeaderView.endTextField.becomeFirstResponder()
        }
        
        preRouteCheck()
    }
}

// MARK: - Search

extension RouteViewController {
    
    func search(keyword: String?) {
        search(keyword: keyword, pointsToExclude: nil, poiType: nil)
    }
    
    func search(keyword: String?, pointsToExclude: [PointOfInterest]?) {
        search(keyword: keyword, pointsToExclude: pointsToExclude, poiType: nil)
    }
    
    func search(keyword: String?, pointsToExclude: [PointOfInterest]?, poiType: PWPointOfInterestType?) {
        guard let floors = mapView.floors else {
            print("No building loaded")
            return
        }
        
        var pois = [PointOfInterest]()
        for floor in floors {
            if let floorPOIs = floor.pointsOfInterest(of: poiType, containing: keyword) {
                pois.append(contentsOf: floorPOIs)
            }
        }
        
        filteredPOIs = pois.sorted(by: {
            guard let title0 = $0.poiTitle, let title1 = $1.poiTitle, let floorName0 = $0.poiFloor.name, let floorName1 = $1.poiFloor.name else {
                return false
            }
            return (floorName0.lowercased(), title0.lowercased()) < (floorName1.lowercased(), title1.lowercased())
        })
        
        buildSectionedPOIs()
        tableView.reloadData()
    }
    
    func buildSectionedPOIs() {
        sectionedPOIs.removeAll()
        for pointOfInterest in filteredPOIs {
            if let buildingName = pointOfInterest.poiBuilding.name {
                if sectionedPOIs[buildingName] != nil {
                    var sectionPOI = sectionedPOIs[buildingName]!
                    sectionPOI.append(pointOfInterest)
                    sectionedPOIs[buildingName] = sectionPOI
                } else {
                    sectionedPOIs[buildingName] = [pointOfInterest]
                }
            }
        }
        
        sortedSectionedPOIKeys = sectionedPOIs.keys.sorted(by: {
            $0.lowercased() < $1.lowercased()
        })
        
        if let index = sortedSectionedPOIKeys.firstIndex(of: self.mapView.currentBuilding.name) {
            sortedSectionedPOIKeys.move(from: index, to: 0)
        }
    }
}

// MARK: - Keyboard Adjustments

extension RouteViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRect = keyboardFrame.cgRectValue
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: keyboardRect.size.height,
                                              right: 0)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
    }
}


