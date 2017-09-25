//
//  ViewController.swift
//  Mapping-Sample
//
//  Created on 5/31/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit
import PWLocation

extension Notification.Name {
    static let startNavigatingRoute = Notification.Name("startNavigatingRoute")
    static let headingUpdated = Notification.Name("headingUpdated")
}

class MapViewController: UIViewController, SegmentedViewController {
    
    @IBOutlet weak var routeInstructionsContainerView: UIView!
    var routeInstructionsViewController: RouteInstructionsViewController!
    
    @IBOutlet weak var mapDirectoryContainerView: UIView!
    var mapDirectoryViewController: DirectoryViewController!
    
    var toolbar: ToolbarView!
    var filteredPOIType: PWPointOfInterestType?
    
    lazy var floorSelectBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named:"floor"), style: .plain, target: self, action:#selector(changeFloor))
        barButton.accessibilityLabel = NSLocalizedString("Floor", comment: "")
        barButton.accessibilityHint = NSLocalizedString("Double tap to change floors", comment: "")
        return barButton
    }()
    
    lazy var categorySelectBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named:"filter"), style: .plain, target: self, action:#selector(changeCategory))
        barButton.accessibilityLabel = NSLocalizedString("Categories", comment: "")
        barButton.accessibilityHint = NSLocalizedString("Double tap to select distance filter", comment: "")
        return barButton
    }()
    
    lazy var trackingBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage.emptyTrackingImage(color: .white), style: .plain, target: self, action: #selector(changeTrackingMode))
        barButton.accessibilityLabel = NSLocalizedString("Tracking Mode Disabled", comment: "")
        barButton.accessibilityHint = NSLocalizedString("Double tap to enabled tracking mode", comment: "")
        return barButton
    }()

    let configurationManager = ConfigurationManager.shared
    
    let mapView = PWMapView()
    let loadingView = UIActivityIndicatorView()
    var firstLocationAcquired = false
    
    var firstLaunch = true
    
    let mapPOITypeSelectionSegue = "MapPOITypeSelection"
    let mapFloorSelectionSegue = "MapFloorSelection"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        view.bringSubview(toFront: routeInstructionsContainerView)
        routeInstructionsContainerView.isHidden = true
        routeInstructionsContainerView.backgroundColor = UIColor.clear
        
        view.bringSubview(toFront: mapDirectoryContainerView)
        mapDirectoryContainerView.isHidden = true

        for childViewController in childViewControllers {
            if let routeInstructionsViewController = childViewController as? RouteInstructionsViewController {
                self.routeInstructionsViewController = routeInstructionsViewController
                self.routeInstructionsViewController.delegate = self
            }
            if let mapDirectoryViewController = childViewController as? DirectoryViewController {
                self.mapDirectoryViewController = mapDirectoryViewController
                self.mapDirectoryViewController.mapView = mapView
            }
        }
        
        loadingView.frame = view.frame
        loadingView.activityIndicatorViewStyle = .whiteLarge
        loadingView.backgroundColor = UIColor.lightGray
        loadingView.alpha = 0.8
        loadingView.startAnimating()
        
        loadBuilding()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startRoute(notification:)), name: .startNavigatingRoute, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func segmentedViewWillAppear() {
        configureToolbar()
    }
    
    func loadBuilding() {
        navigationController?.view.addSubview(loadingView)
        let buildingId = ConfigurationManager.shared.currentConfiguration.buildingId
        
        PWBuilding.building(withIdentifier: buildingId!) { [weak self] (building, error) in
            guard let building = building, error == nil else {
                print(error!.localizedDescription)
                return
            }
            self?.configurationManager.currentConfiguration.loadedBuilding = building
            self?.mapView.setBuilding(building)
            
            let managedLocationManager = PWManagedLocationManager.init(buildingId: buildingId!)
            
            self?.loadingView.removeFromSuperview()
            DispatchQueue.main.async {
                self?.mapView.register(managedLocationManager)
            }
        }
    }

    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == mapPOITypeSelectionSegue {
            if let navController = segue.destination as? UINavigationController, let poiTypeSelectionViewController = navController.topViewController as? POITypeSelectionViewController {
                poiTypeSelectionViewController.selectedPOIType = filteredPOIType
                poiTypeSelectionViewController.poiTypes = mapView.building.availablePOITypes()
                poiTypeSelectionViewController.poiSelectedCompletion = { [weak self] selectedPOI in
                    self?.filteredPOIType = selectedPOI
                    self?.filterMapPOIByType(poiType: selectedPOI)
                }
            }
        } else if identifier == mapFloorSelectionSegue, let navController = segue.destination as? UINavigationController {
            if let mapFloorSelectionViewController = navController.topViewController as? MapFloorSelectionViewController {
                mapFloorSelectionViewController.mapView = mapView
            }
        }
    }
    
    func filterMapPOIByType(poiType: PWPointOfInterestType?) {
        guard let pointsOfInterest = mapView.currentFloor.pointsOfInterest as? [PWPointOfInterest] else {
            return
        }
        
        for poi in pointsOfInterest {
            if let view = mapView.viewForPoint(poi) {
                if let poiType = poiType {
                    view.isHidden = poiType.identifier != poi.pointOfInterestType!.identifier
                } else {
                    view.isHidden = false
                }
            }
        }
    }
}

// MARK: - PWMapViewDelegate

extension MapViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, locationManager: PWLocationManager!, didUpdateIndoorUserLocation userLocation: PWIndoorLocation!) {
        if !firstLocationAcquired {
            firstLocationAcquired = true
            mapView.trackingMode = .follow
        }
		NotificationCenter.default.post(name: .updateIndoorLocation, object: userLocation)
    }
    
    func mapView(_ mapView: PWMapView!, didUpdate heading: CLHeading!) {
        NotificationCenter.default.post(name: .headingUpdated, object: heading)
    }
    
    func mapView(_ mapView: PWMapView!, didChange mode: PWTrackingMode) {
        var newTrackingModeImage = UIImage.emptyTrackingImage(color: .white)
        switch mode {
        case .none:
            newTrackingModeImage = UIImage.emptyTrackingImage(color: .white)
        case .follow:
            newTrackingModeImage = UIImage.filledTrackingImage(color: .white)
        case .followWithHeading:
            newTrackingModeImage = UIImage.trackWithHeadingImage(color: .white)
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.trackingBarButton.image = newTrackingModeImage
        }
    }
}

// MARK: - RouteInstructionViewControllerDelegate

extension MapViewController: RouteInstructionViewControllerDelegate {
    
    func didChangeRouteInstruction(route: PWRoute, routeInstruction: PWRouteInstruction) {
        mapView.setRouteManeuver(routeInstruction)
    }
}

// MARK: - Routing

extension MapViewController {
    
    func startRoute(notification: Notification) {
        if let route = notification.object as? PWRoute {
            mapView.navigate(with: route)
            mapView.trackingMode = .followWithHeading
            
            routeInstructionsViewController.route = route
            routeInstructionsContainerView.isHidden = false
        }
    }
    
    func cancelRoute() {
        mapView.cancelRouting()
        routeInstructionsContainerView.isHidden = true
    }
}

// MARK: - Toolbar

extension MapViewController {
    
    func configureToolbar() {
        toolbar.setItems([categorySelectBarButton, toolbar.flexibleBarSpace, floorSelectBarButton, toolbar.flexibleBarSpace, trackingBarButton], animated: true)
        mapDirectoryViewController.toolbar = toolbar
    }
    
    func changeFloor() {
        performSegue(withIdentifier: mapFloorSelectionSegue, sender: self)
    }
    
    func changeCategory() {
        performSegue(withIdentifier: mapPOITypeSelectionSegue, sender: self)
    }
    
    func changeTrackingMode() {
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
