//
//  ViewController.swift
//  LocationSharing
//
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit
import PWLocation

class ViewController: UIViewController {

    let buildingIdentifier = 0 /* Replace with your building identifier found on your building's edit page of MaaS portal*/
    
    let mapView = PWMapView()
    var firstLocationAcquired = false
    
    let deviceDisplayNameKey = "DeviceDisplayNameKey"
    var deviceDisplayName: String {
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
    
    let deviceTypeKey = "DeviceTypeKey"
    var deviceType: String {
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
    
    var sharedLocations = Set<PWSharedLocation>()
    var sharedLocationAnnotations = [String : SharedLocationAnnotation]()
    
    var annotationColors = [String : UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        // Set the location sharing delegate to receive the call backs on update
        mapView.locationSharingDelegate = self
        
        // Set the display name for the shared location
        mapView.sharedLocationDisplayName = deviceDisplayName
        
        // Set the user type for the shared location
        mapView.sharedLocationUserType = deviceType
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: false, onCompletion: { (error) in
                if let buildingIdentifier = self?.buildingIdentifier {
                    let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingIdentifier)
                    
                    DispatchQueue.main.async {
                        self?.mapView.register(managedLocationManager)
                        self?.mapView.trackingMode = .follow
                        
                        // Start sharing the device/user location
                        self?.mapView.startSharingUserLocation()
                        
                        // Start retrieving the shared locations
                        self?.mapView.startRetrievingSharedLocations()
                    }
                }
            })
        }
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0))
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

// MARK: - CGFloat extension

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: - PWMapViewDelegate

extension ViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        
        if let annotation = annotation as? SharedLocationAnnotation {
            annotationView = sharedLocationAnnotationView(sharedLocationAnnotation: annotation, mapView: mapView)
        }
        
        return annotationView
    }
}

// MARK: - Interface Actions

extension ViewController {
    
    @IBAction func settingsTapped(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Set device name and type", message: nil, preferredStyle: .alert)
        
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

// MARK: - PWLocationSharingDelegate

extension ViewController: PWLocationSharingDelegate {
    
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
