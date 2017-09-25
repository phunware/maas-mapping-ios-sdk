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
    let buildingIdentifier = 59770
    
    let mapView = PWMapView()
    var firstLocationAcquired = false
    
    var manager: PWManagedLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        manager = PWManagedLocationManager.init(buildingId: buildingIdentifier)
        manager.delegate = self
        manager.startUpdatingLocation()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building)
            
            if let buildingIdentifier = self?.buildingIdentifier {
//                let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingIdentifier)
                
                DispatchQueue.main.async {
//                    self?.mapView.register(managedLocationManager)
                }
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
    
    func mapViewDidFailLoadingMap(_ mapView: PWMapView!, withError error: Error!) {
        print("\(error)")
    }
}

extension ViewController: PWLocationManagerDelegate {
    
    func locationManager(_ manager: PWLocationManager!, failedWithError error: Error!) {
        print("\(error)")
    }
    
    func locationManager(_ manager: PWLocationManager!, didUpdateTo location: PWLocationProtocol!) {
        print("?")
    }
}
