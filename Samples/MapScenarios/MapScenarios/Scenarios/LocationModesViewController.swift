//
//  LocationModesViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit
import PWCore

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

class LocationModesViewController: UIViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var trackingModeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Location Modes"
        
        if !validateBuildingSetting(appId: applicationId, accessKey: accessKey, signatureKey: signatureKey, buildingId: buildingIdentifier) {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        trackingModeButton.image = .emptyTrackingImage(color: .blue)

        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                self?.locationManager.delegate = self
                if !CLLocationManager.isAuthorized() {
                    self?.locationManager.requestWhenInUseAuthorization()
                } else {
                    self?.startManagedLocationManager()
                }
            })
        }
    }
    
    func startManagedLocationManager() {
        DispatchQueue.main.async { [weak self] in
            guard let buildingIdentifier = self?.buildingIdentifier else {
                return
            }
            let managedLocationManager = PWManagedLocationManager(buildingId: buildingIdentifier)
            self?.mapView.register(managedLocationManager)
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
