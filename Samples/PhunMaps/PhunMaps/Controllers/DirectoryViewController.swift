//
//  DirectoryViewController.swift
//  Mapping-Sample
//
//  Created on 6/16/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

protocol DirectoryViewControllerDelegate {
    
    func didSelectPOI(selectedPOI: PWPointOfInterest)
}

class DirectoryViewController: UIViewController, SegmentedViewController, POISearchable {
    
    var toolbar: ToolbarView!
    weak var mapView: PWMapView?
    var delegate: DirectoryViewControllerDelegate?
    
    var filteredPOIs: [PWPointOfInterest]!
    var sectionedPOIs: [String : [PWPointOfInterest]]!
    var sortedSectionedPOIKeys: [String]!
    var searchKeyword: String? {
        didSet {
            search(keyword: searchKeyword, pointsToExclude: nil, poiType: filteredPOIType)
        }
    }
    var filteredPOIType: PWPointOfInterestType? {
        didSet {
            search(keyword: searchKeyword, pointsToExclude: nil, poiType: filteredPOIType)
        }
    }
    
    lazy var categorySelectBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named:"filter"), style: .plain, target: self, action:#selector(changeCategory))
        barButton.accessibilityLabel = NSLocalizedString("Categories", comment: "")
        barButton.accessibilityHint = NSLocalizedString("Double tap to select category filter", comment: "")
        return barButton
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let configurationManager = ConfigurationManager.shared
    fileprivate var selectedPOI: PWPointOfInterest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredPOIs = [PWPointOfInterest]()
        sectionedPOIs = [String : [PWPointOfInterest]]()
        sortedSectionedPOIKeys = [String]()
		
		tableView.register(UINib(nibName: "POITableViewCell", bundle: nil), forCellReuseIdentifier: POICellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    func segmentedViewWillAppear() {
        search(keyword: searchKeyword, pointsToExclude: nil, poiType: filteredPOIType)
        configureToolbar()
    }
    
    func segmentedViewWillDisappear() { }
        
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
                    self?.search(keyword: self?.searchKeyword, pointsToExclude: nil, poiType: selectedPOI)
                }
            }
        } else if identifier == String(describing: POIDetailsViewController.self), let destination = segue.destination as? POIDetailsViewController {
            destination.pointOfInterest = selectedPOI
            destination.userLocation = mapView?.indoorUserLocation
        }
    }
}

// MARK: - UITableViewDataSource

extension DirectoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedPOIs.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[section]] {
            return pois.count
        }
        
        return sectionedPOIs.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: POICellIdentifier, for: indexPath) as! POITableViewCell
		
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[indexPath.section]] {
            let poi = pois[indexPath.row]
			cell.setPointOfInterest(poi: poi)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
    
extension DirectoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let pois = sectionedPOIs[sortedSectionedPOIKeys[indexPath.section]] {
            selectedPOI = pois[indexPath.row]
            if let delegate = delegate {
                delegate.didSelectPOI(selectedPOI: selectedPOI!)
            } else {
                performSegue(withIdentifier: String(describing: POIDetailsViewController.self), sender: nil)
            }
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedSectionedPOIKeys
    }
}

// MARK: - Toolbar

extension DirectoryViewController {
    
    func configureToolbar() {
        toolbar.setItems([categorySelectBarButton], animated: true)
    }
    
    @objc func changeCategory() {
        performSegue(withIdentifier: mapPOITypeSelectionSegue, sender: self)
    }
}
