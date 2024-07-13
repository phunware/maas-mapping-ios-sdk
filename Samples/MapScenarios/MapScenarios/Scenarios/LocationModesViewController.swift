//
//  LocationModesViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWCore
import PWLocation
import PWMapKit

// MARK: - LocationModesViewController
class LocationModesViewController: UIViewController, ScenarioProtocol {
    
    // Enter your application identifier and access key found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0

    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    private let mapView = PWMapView()
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var trackingModeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Location Modes"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        trackingModeButton.image = .emptyTrackingImage(color: .blue)

        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] result in
                switch result {
                case .success(let campus):
                    self?.mapView.setCampus(campus, animated: true, onCompletion: { (error) in
                        self?.locationManager.delegate = self
                        if !CLLocationManager.isAuthorized() {
                            self?.locationManager.requestWhenInUseAuthorization()
                        } else {
                            self?.startManagedLocationManager()
                        }
                    })
                    
                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
        else {
            PWBuilding.building(identifier: buildingIdentifier) { [weak self] result in
                switch result {
                case .success(let building):
                    self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                        self?.locationManager.delegate = self
                        if !CLLocationManager.isAuthorized() {
                            self?.locationManager.requestWhenInUseAuthorization()
                        } else {
                            self?.startManagedLocationManager()
                        }
                    })
                    
                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
    }
    
    func startManagedLocationManager() {
        
        // In order to route between buildings on a campus, we also need to register the
        // PWManagedLocationManager using campusIdentifier.  Otherwise, we will register
        // using buildingIdentifier.
        if campusIdentifier != 0 {
            DispatchQueue.main.async { [weak self] in
                guard let campusIdentifier = self?.campusIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(campusId: campusIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                guard let buildingIdentifier = self?.buildingIdentifier else {
                    return
                }
                let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
                self?.mapView.register(managedLocationManager)
            }
        }
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @IBAction func trackingModeButtonTapped(_ sender: Any) {
        switch mapView.trackingMode {
        case .none:
            mapView.trackingMode = .follow
        case .follow:
            mapView.trackingMode = .followWithHeading
        case .followWithHeading:
            mapView.trackingMode = .none
        }
    }
}

// MARK: - PWMapViewDelegate
extension LocationModesViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, didChangeIndoorUserTrackingMode mode: PWTrackingMode) {
        switch mode {
        case .none:
            trackingModeButton.image = .emptyTrackingImage(color: .blue)
        case .follow:
            trackingModeButton.image = .filledTrackingImage(color: .blue)
        case .followWithHeading:
            trackingModeButton.image = .trackWithHeadingImage(color: .blue)
        }
    }
    
    func mapView(_ mapView: PWMapView!, didFailToLocateIndoorUserWithError error: Error!) {
        guard let error = error as NSError? else {
            return
        }
        
        let title = error.domain
        let description = error.userInfo["message"] as? String ?? "Unknown Error"
        let message = "\(description) \n Error Code: \(error.code)"
        
        showAlertForIndoorLocationFailure(withTitle: title , failureMessage: message)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationModesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startManagedLocationManager()
        default:
            mapView.unregisterLocationManager()
            print("Not authorized to start PWLocationManager")
        }
    }
}

// MARK: UIImage Extension
extension UIImage {
    
    class func emptyTrackingImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 26, height: 26)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 13.53, y: 24))
        bezierPath.addLine(to: CGPoint(x: 13.44, y: 10.62))
        bezierPath.addLine(to: CGPoint(x: 0, y: 10.71))
        bezierPath.addLine(to: CGPoint(x: 24, y: 0))
        bezierPath.addLine(to: CGPoint(x: 13.53, y: 24))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 14.31, y: 9.74))
        bezierPath.addLine(to: CGPoint(x: 14.38, y: 19.85))
        bezierPath.addLine(to: CGPoint(x: 22.29, y: 1.7))
        bezierPath.addLine(to: CGPoint(x: 4.16, y: 9.81))
        bezierPath.addLine(to: CGPoint(x: 14.31, y: 9.74))
        bezierPath.close()
        bezierPath.miterLimit = 4
        
        color.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            return image
        }
        return UIImage()
    }
    
    class func filledTrackingImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 26, height: 26)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 12.4, y: 22))
        bezierPath.addLine(to: CGPoint(x: 12.33, y: 9.74))
        bezierPath.addLine(to: CGPoint(x: 0, y: 9.81))
        bezierPath.addLine(to: CGPoint(x: 22, y: 0))
        bezierPath.addLine(to: CGPoint(x: 12.4, y: 22))
        bezierPath.close()
        bezierPath.miterLimit = 4
        
        color.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            return image
        }
        return UIImage()
    }
    
    class func trackWithHeadingImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 26, height: 26)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 6.98, y: 0))
        bezierPath.addLine(to: CGPoint(x: 8, y: 0))
        bezierPath.addLine(to: CGPoint(x: 8, y: 6.01))
        bezierPath.addLine(to: CGPoint(x: 6.98, y: 6.01))
        bezierPath.addLine(to: CGPoint(x: 6.98, y: 0))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 7.44, y: 19.01))
        bezierPath.addLine(to: CGPoint(x: 0, y: 26))
        bezierPath.addLine(to: CGPoint(x: 7.39, y: 8.01))
        bezierPath.addLine(to: CGPoint(x: 15, y: 25.91))
        bezierPath.addLine(to: CGPoint(x: 7.44, y: 19.01))
        bezierPath.close()
        bezierPath.miterLimit = 4
        
        color.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            return image
        }
        return UIImage()
    }
}
