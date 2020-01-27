//
//  LocationSharingViewController.swift
//  MapScenarios
//
//  Created on 3/12/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit
import PWCore

// MARK: - CGFloat extension
extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: - SharedLocationAnnotation
class SharedLocationAnnotation: MKPointAnnotation {
    
    var sharedLocation: PWSharedLocation!
    
    init(sharedLocation: PWSharedLocation) {
        super.init()
        self.sharedLocation = sharedLocation
    }
}

// MARK: - Notification
extension Notification.Name {
    static let didUpdateAnnotation = Notification.Name("didUpdateAnnotation")
}

// MARK: - SharedLocationAnnotationView
class SharedLocationAnnotationView: MKAnnotationView {
    
    let floatingTextLabel = UILabel()
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, color: UIColor) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateAnnotation), name: .didUpdateAnnotation, object: nil)
        
        configureFloatingTextLabel()
        
        image = circleImageWithColor(color: color, height: 15.0)
    }
    
    func circleImageWithColor(color: UIColor, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: height, height: height), false, 0)
        let fillPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: height, height: height))
        color.setFill()
        fillPath.fill()
        
        let dotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return dotImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Floating Text Label
extension SharedLocationAnnotationView {
    
    func configureFloatingTextLabel() {
        addSubview(floatingTextLabel)
        floatingTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addFloatingText(_ text: String) {
        floatingTextLabel.text = text
        floatingTextLabel.sizeToFit()
        
        floatingTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        floatingTextLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
    }
    
    @objc func didUpdateAnnotation() {
        DispatchQueue.main.async { [weak self] in
            guard let annotation = self?.annotation as? SharedLocationAnnotation else {
                return
            }
            
            self?.addFloatingText("\(annotation.sharedLocation.displayName!) (\(annotation.sharedLocation.userType!))")
        }
    }
}

// MARK: - LocationSharingViewController
class LocationSharingViewController: UIViewController, ScenarioProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    private let mapView = PWMapView()
    private let locationManager = CLLocationManager()
    private var firstLocationAcquired = false
    
    private let deviceDisplayNameKey = "DeviceDisplayNameKey"
    private var deviceDisplayName: String {
        get {
            if let displayName = UserDefaults.standard.object(forKey: deviceDisplayNameKey) as? String {
                return displayName
            }
            return "Test"
        }
        set {
            mapView.sharedLocationDisplayName = newValue
            UserDefaults.standard.set(newValue, forKey: deviceDisplayNameKey)
        }
    }
    
    private let deviceTypeKey = "DeviceTypeKey"
    private var deviceType: String {
        get {
            if let type = UserDefaults.standard.object(forKey: deviceTypeKey) as? String {
                return type
            }
            return "Employee"
        }
        set {
            mapView.sharedLocationUserType = newValue
            UserDefaults.standard.set(newValue, forKey: deviceTypeKey)
        }
    }
    
    private var sharedLocations = Set<PWSharedLocation>()
    private var sharedLocationAnnotations = [String : SharedLocationAnnotation]()
    
    private var annotationColors = [String : UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Location Sharing"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        mapView.delegate = self
        mapView.locationSharingDelegate = self
        mapView.sharedLocationDisplayName = deviceDisplayName
        mapView.sharedLocationUserType = deviceType
        view.addSubview(mapView)
        configureMapViewConstraints()
        
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
            self?.mapView.startSharingUserLocation()
            self?.mapView.startRetrievingSharedLocations()
            
            if let strongSelf = self {
                strongSelf.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: strongSelf, action: #selector(strongSelf.settingsTapped))
            }
        }
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func sharedLocationAnnotationView(sharedLocationAnnotation: SharedLocationAnnotation, mapView: MKMapView) -> SharedLocationAnnotationView {
        var dotView = mapView.dequeueReusableAnnotationView(withIdentifier: sharedLocationAnnotation.sharedLocation.deviceId) as? SharedLocationAnnotationView
        
        if dotView == nil {
            var color = UIColor.black
            if let oldColor = annotationColors[sharedLocationAnnotation.sharedLocation.deviceId] {
                color = oldColor
            } else {
                let newColor = UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
                color = newColor
                annotationColors[sharedLocationAnnotation.sharedLocation.deviceId] = color
            }
            
            dotView = SharedLocationAnnotationView(annotation: sharedLocationAnnotation, reuseIdentifier: sharedLocationAnnotation.sharedLocation.deviceId, color: color)
            if let title = sharedLocationAnnotation.title {
                dotView!.addFloatingText(title)
            }
        }
        
        return dotView!
    }
}

// MARK: - PWMapViewDelegate
extension LocationSharingViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        
        if let annotation = annotation as? SharedLocationAnnotation {
            annotationView = sharedLocationAnnotationView(sharedLocationAnnotation: annotation, mapView: mapView)
        }
        
        return annotationView
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

// MARK: - PWLocationSharingDelegate
extension LocationSharingViewController: PWLocationSharingDelegate {
    
    // Called when the shared locations are updated. Includes complete list of shared locations
    
    func didUpdate(_ sharedLocations: Set<PWSharedLocation>!) {
        self.sharedLocations = sharedLocations
        
        for updatedSharedLocation in sharedLocations {
            if let annotation = sharedLocationAnnotations[updatedSharedLocation.deviceId] {
                annotation.sharedLocation = updatedSharedLocation
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        annotation.title = "\(updatedSharedLocation.displayName!) (\(updatedSharedLocation.userType!))"
                        annotation.coordinate = updatedSharedLocation.location
                    })
                }
            }
        }
        
        NotificationCenter.default.post(name: .didUpdateAnnotation, object: nil)
    }
    
    // Called when a new shared location is added
    
    func didAdd(_ addedSharedLocations: Set<PWSharedLocation>!) {
        for addedSharedLocation in addedSharedLocations {
            DispatchQueue.main.async { [weak self] in
                let annotation = SharedLocationAnnotation(sharedLocation: addedSharedLocation)
                annotation.title = "\(addedSharedLocation.displayName!) (\(addedSharedLocation.userType!))"
                annotation.coordinate = addedSharedLocation.location
                
                self?.sharedLocationAnnotations[addedSharedLocation.deviceId] = annotation
                self?.mapView.addAnnotation(annotation)
            }
        }
    }
    
    // Called when a shared location is removed
    
    func didRemove(_ removedSharedLocations: Set<PWSharedLocation>!) {
        for removedSharedLocation in removedSharedLocations {
            DispatchQueue.main.async { [weak self] in
                if let annotation = self?.sharedLocationAnnotations[removedSharedLocation.deviceId] {
                    self?.mapView.removeAnnotation(annotation)
                    self?.sharedLocationAnnotations.removeValue(forKey: removedSharedLocation.deviceId)
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationSharingViewController: CLLocationManagerDelegate {
    
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

// MARK: - Settings Button
extension LocationSharingViewController {
    
    @objc func settingsTapped() {
        let alertController = UIAlertController(title: "Set device name and type", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak self] (alertAction) in
            if let displayName = alertController.textFields?[0].text {
                self?.deviceDisplayName = displayName
            }
            if let type = alertController.textFields?[1].text {
                self?.deviceType = type
            }
        }))
        
        alertController.addTextField { [weak self] (textField) in
            textField.text = self?.deviceDisplayName
        }
        alertController.addTextField { [weak self] (textField) in
            textField.text = self?.deviceType
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
