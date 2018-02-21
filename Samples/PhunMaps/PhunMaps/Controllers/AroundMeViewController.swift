//
//  AroundMeViewController.swift
//  Mapping-Sample
//
//  Created on 6/16/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit
import PWLocation

extension Notification.Name {
	static let updateIndoorLocation = Notification.Name("updateIndoorLocation")
}

class AroundMeViewController: UIViewController, SegmentedViewController, POISearchable {
    
	@IBOutlet weak var tableView: UITableView!
	
    var toolbar: ToolbarView!
	weak var mapView: PWMapView?
    var filteredPOIType: PWPointOfInterestType? {
        didSet {
            search(keyword: searchKeyword)
            configureHeaderView()
        }
    }
	
	var filteredPOIs: [PWPointOfInterest]!
	var sectionedPOIs: [String : [PWPointOfInterest]]!
	var sortedSectionedPOIKeys: [String]!	
	
    var filterRadius : NSNumber! {
        didSet {
            configureHeaderView()
            search(keyword: searchKeyword)
        }
    }
	var lastLocation: PWIndoorLocation!
    var selectedPOI: PWPointOfInterest?
    var searchKeyword: String? {
        didSet {
            search(keyword: searchKeyword)
        }
    }
    var headerView: AroundMeHeaderView?
	
	lazy var categorySelectBarButton: UIBarButtonItem = {
		let barButton = UIBarButtonItem(image: UIImage(named:"filter"), style: .plain, target: self, action:#selector(changeCategory))
		barButton.accessibilityLabel = NSLocalizedString("Categories", comment: "")
		barButton.accessibilityHint = NSLocalizedString("Double tap to select category filter", comment: "")
		return barButton
	}()
	
	lazy var distanceFilterBarButton: UIBarButtonItem = {
		let barButton = UIBarButtonItem(image: UIImage(named:"distance"), style: .plain, target: self, action:#selector(changeFilter))
		barButton.accessibilityLabel = NSLocalizedString("Distance", comment: "Distance")
		barButton.accessibilityHint = NSLocalizedString("Double tap to select distance filter", comment: "")
		return barButton
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		filteredPOIs = [PWPointOfInterest]()
		sectionedPOIs = [String : [PWPointOfInterest]]()
		filterRadius = CommonSettingsConstants.Distance.defaultSearchRadius as NSNumber
		
		sortedSectionedPOIKeys = [String]()
		tableView.register(UINib(nibName: "POITableViewCell", bundle: nil), forCellReuseIdentifier: POICellIdentifier)
        tableView.register(UINib(nibName: String(describing: AroundMeHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: AroundMeHeaderView.self))
        
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionHeaderHeight = 60.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureHeaderView()
	}
	
	func segmentedViewWillAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation(notification:)), name: .updateIndoorLocation, object: nil)
		search(keyword: nil)
		configureHeaderView()
        configureToolbar()
	}
    
    func segmentedViewWillDisappear() {
        NotificationCenter.default.removeObserver(self, name: .updateIndoorLocation, object: nil)
    }
	
	func configureHeaderView() {
		if lastLocation == nil {
			headerView?.currentlyAtLabel.text = NSLocalizedString("One second, we are having a hard time finding your position.", comment: "")
			headerView?.followingAreWithinContainerHeightConstraint.constant = 0
			return
		}
		
        if filteredPOIs.count == 0 {
			headerView?.currentlyAtLabel.text = NSLocalizedString("Sorry, we couldn’t find any matching point of interest within 25 feet of you.", comment: "")
            headerView?.nearestPOILabel.text = ""
			headerView?.followingAreWithinContainerHeightConstraint.constant = 0
			return
		}
		
		headerView?.currentlyAtLabel.text = NSLocalizedString("Currently At:", comment: "")
		headerView?.followingAreWithinContainerHeightConstraint.constant = 30
		
		if let nearestPOI = filteredPOIs.first {
			headerView?.nearestPOILabel.text = nearestPOI.title! + " " + nearestPOI.floor.name!
        }
		
		headerView?.followingAreWithinLabel.text = NSLocalizedString("Following are within \(filterRadius!) feet", comment: "")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		if identifier == mapPOITypeSelectionSegue {
			if let navController = segue.destination as? UINavigationController, let poiTypeSelectionViewController = navController.topViewController as? POITypeSelectionViewController {
				poiTypeSelectionViewController.selectedPOIType = filteredPOIType
				poiTypeSelectionViewController.poiTypes = (mapView?.building.availablePOITypes())!
				poiTypeSelectionViewController.poiSelectedCompletion = { [weak self] selectedPOI in
					self?.filteredPOIType = selectedPOI
					self?.search(keyword: self?.searchKeyword)
                }
            }
        } else if identifier == String(describing: POIDetailsViewController.self), let destination = segue.destination as? POIDetailsViewController {
            destination.pointOfInterest = selectedPOI
            destination.userLocation = mapView?.indoorUserLocation
        }
    }
	
	func filterMapPOIByType(poiType: PWPointOfInterestType?) {
		guard let pointsOfInterest = mapView?.currentFloor.pointsOfInterest as? [PWPointOfInterest] else {
			return
		}
		
		for poi in pointsOfInterest {
			if let view = mapView?.view(for: poi) {
				if let poiType = poiType {
					view.isHidden = poiType.identifier != poi.pointOfInterestType!.identifier
				} else {
					view.isHidden = false
				}
			}
        }
    }
    
    func search(keyword: String?) {
        guard let building = ConfigurationManager.shared.currentConfiguration.loadedBuilding, let floors = building.floors as? [PWFloor], lastLocation != nil else {
            print("No building loaded")
            return
        }
        
        var pois = [PWPointOfInterest]()
        
        let userLocation = CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        for floor in floors {
            if floor.floorID == lastLocation.floorID {
                for poi in floor.pointsOfInterest(of: filteredPOIType, containing: keyword) {
                    if let poi = poi as? PWPointOfInterest {
                        let poiLocation = CLLocation(latitude: poi.coordinate.latitude, longitude: poi.coordinate.longitude)
                        let distanceInMeters = userLocation.distance(from: poiLocation)
                        let distanceInFeet = CommonSettings.feetFromMeters(distanceInMeters)
                        
                        if distanceInFeet < filterRadius.doubleValue {
                            pois.append(poi)
                        }
                    }
                }
            }
        }
        
        if pois.count > 0 {
            filteredPOIs = pois.sorted(by: { (poi1, poi2) -> Bool in
                let dist1 = CLLocation(latitude: poi1.coordinate.latitude, longitude: poi1.coordinate.longitude).distance(from: userLocation)
                let dist2 = CLLocation(latitude: poi2.coordinate.latitude, longitude: poi2.coordinate.longitude).distance(from: userLocation)
                return dist1 < dist2
            })
        } else {
            filteredPOIs = [PWPointOfInterest]()
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension AroundMeViewController: UITableViewDataSource {
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POICellIdentifier, for: indexPath) as! POITableViewCell
        if filteredPOIs.count > 0 {
            let poi = filteredPOIs[indexPath.row]
            cell.setPointOfInterest(poi: poi)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPOIs.count
	}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerView == nil {
            if let aroundMeHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: AroundMeHeaderView.self)) as? AroundMeHeaderView {
                headerView = aroundMeHeaderView
            }
        }
        
        configureHeaderView()
        
        return headerView
    }
}

// MARK: - UITableViewDelegate

extension AroundMeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if filteredPOIs.count > 0 {
            selectedPOI = filteredPOIs[indexPath.row]
            performSegue(withIdentifier: String(describing: POIDetailsViewController.self), sender: nil)
        }
    }
}

// MARK: - PWMapViewDelegate

extension AroundMeViewController {
    
	func updateLocation(notification: NSNotification) {
		if let userlocation = notification.object as? PWIndoorLocation {
			if lastLocation == nil || abs(lastLocation.timestamp.timeIntervalSinceNow) > 2 {
				lastLocation = userlocation
			}
		}
		configureHeaderView()
        search(keyword: searchKeyword)
	}
}

// MARK: - Toolbar

extension AroundMeViewController {
	func configureToolbar() {
		toolbar.setItems([categorySelectBarButton, toolbar.flexibleBarSpace, distanceFilterBarButton], animated: true)
	}
	
	func changeCategory() {
		performSegue(withIdentifier: mapPOITypeSelectionSegue, sender: self)
	}

	func changeFilter() {
		let alertController = CommonSettings.buildActionSheetWithItems(CommonSettingsConstants.Distance.filterDistances as [AnyObject], displayProperty: nil, selectedItem:filterRadius, title:NSLocalizedString("Change Distance", comment:"SheetTitleForDistance"), actionNameFormat:NSLocalizedString("%@ feet", comment:"") , topAction: nil) { [weak self] (selection) in
            if let distance = selection as? Int {
                self?.filterRadius = NSNumber(integerLiteral: distance)
            }
		}
		present(alertController, animated: true, completion: nil)
	}
}
