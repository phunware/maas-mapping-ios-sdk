## Sample - Location Sharing

### Overview

- Show current location in building.
- Show current location of other users of the app in the same building on the map.

### Usage:
- Fill out `applicationId`, `accessKey`, `signatureKey`, and `buildingIdentifier`.
- Tap "Settings" button to change device name or type.
- Required to have at least two unique device identifiers with blue dot in the same building to see usage.


### Sample Code:
- [LocationSharingViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/LocationSharingViewController.swift)

**Step 1: Create annotion for shared location**

```
// MARK: - SharedLocationAnnotation
class SharedLocationAnnotation: MKPointAnnotation {
    
    var sharedLocation: PWSharedLocation!
    
    init(sharedLocation: PWSharedLocation) {
        super.init()
        self.sharedLocation = sharedLocation
    }
}
```

**Step 2: Create annotation view for shared location**

```
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
```

**Step 3: Start location sharing and subscribe to the updates**

```
mapView.delegate = self
mapView.locationSharingDelegate = self

let managedLocationManager = PWManagedLocationManager(buildingId: #buildingIdentifier#)
mapView.register(managedLocationManager)
mapView.startSharingUserLocation()
mapView.startRetrievingSharedLocations()
```

**Step 4: Render annotation view for shared locations**

```
extension LocationSharingViewController: PWMapViewDelegate {
    
    // Start follow me mode once get user's current location
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWUserLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
    }
    
    // Render annotations for shared location
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        
        if let annotation = annotation as? SharedLocationAnnotation {
            annotationView = sharedLocationAnnotationView(sharedLocationAnnotation: annotation, mapView: mapView)
        }
        
        return annotationView
    }
}

// Helper method

extension LocationSharingViewController {

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
```

**Step 5: Handle shared locaton update**

```
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
```


# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/

