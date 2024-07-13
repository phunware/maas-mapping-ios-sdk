//
//  CustomPointOfInterestImagesViewController.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 3/23/20.
//  Copyright © 2020 Phunware. All rights reserved.
//

import Foundation
import PWMapKit
import PWCore

// MARK: - CustomPointOfInterestImagesViewController
class CustomPointOfInterestImagesViewController: UIViewController, ScenarioProtocol {
    
    // Enter your application identifier and access key found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0

    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    // The starting center coordinate for the camera view. Set this to be the location of your building
    // (or close to it) so that the camera will already be close to the building location before the building loads.
    private let initialCenterCoordinate = CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129)
    
    // The how many meters the camera will display of the map from the center point.
    // Set to a lower value if you would like the camera to start zoomed in more.
    private let initialCameraDistance: CLLocationDistance = 10000000
    
    private let mapView = PWMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Custom POI Image"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
                
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        // Set our custom POI image loader here before we load the building. Normally, you would probably do this when your application launches.
        PWBuilding.customImageLoaderForPointsOfInterest = { poiInfo, setImage in
            // For demo purposes, we'll just use the same image for all POIs, loaded from the asset catalog. However, you may inspect the poiInfo object to
            // determine which image to load, e.g. if you are loading an image for each POI type.
            let image = UIImage(named: "CustomPOI")
            
            // You must call the provided function to set your image once you have it, or 'nil' to fall back to default image loading.
            // If you do not call the provided function, you images for POIs will not appear, so make sure you always call it.
            // (NOTE: It is okay to call this function asynchronously).
            setImage(image)
        }
        
        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] result in
                switch result {
                case .success(let campus):
                    self?.mapView.setCampus(campus, animated: true, onCompletion: nil)

                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
        else {            
            PWBuilding.building(identifier: buildingIdentifier) { [weak self] result in
                switch result {
                case .success(let building):
                    self?.mapView.setBuilding(building, animated: true, onCompletion: nil)

                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset the custom POI image loader before returning to the sample menu
        PWBuilding.customImageLoaderForPointsOfInterest = nil
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
