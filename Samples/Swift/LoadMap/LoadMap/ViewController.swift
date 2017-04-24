//
//  ViewController.swift
//  LoadMap
//
//  Created on 4/24/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit
import PWLocation

class ViewController: UIViewController {
    let buildingIdentifier = 0
    
    let mapView = PWMapView()
    var firstLocationAcquired = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building)
            
            let managedLocationManager = PWManagedLocationManager.init(buildingId: (self?.buildingIdentifier)!)
            
            DispatchQueue.main.async {
                self?.mapView.register(managedLocationManager)
            }
        }
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0))
    }
}

extension ViewController: PWMapViewDelegate {
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWIndoorLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
    }
}
