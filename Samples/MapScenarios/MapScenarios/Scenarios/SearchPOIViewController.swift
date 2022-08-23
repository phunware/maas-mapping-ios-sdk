//
//  SearchPOIViewController.swift
//  MapScenarios
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit
import PWCore

// MARK: - SearchPOIViewController
class SearchPOIViewController: UIViewController, ScenarioProtocol {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    var applicationId = ""
    var accessKey = ""
    var signatureKey = ""
    
    // Enter your campus identifier here, found on the campus's Edit page on Maas portal
    var campusIdentifier = 0

    // Enter your building identifier here, found on the building's Edit page on Maas portal
    var buildingIdentifier = 0
    
    private let mapView = PWMapView()
    
    // Search view
    private let tableView = UITableView()
    private let poiCellReuseIdentifier = "POICell"
    private var pointsOfInterest = [PWPointOfInterest]()
    private var filteredPointsOfInterest = [PWPointOfInterest]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search for Points of Interest"
        
        if !validateScenarioSettings() {
            return
        }
        
        PWCore.setApplicationID(applicationId, accessKey: accessKey)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        mapView.delegate = self
        view.addSubview(mapView)
        configureMapViewConstraints()
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        addFloorPickerView()
                
        // If we want to route between buildings on a campus, then we use PWCampus.campus to configure MapView
        // Otherwise, we will use PWBuilding.building to route between floors in a single building.
        if campusIdentifier != 0 {
            PWCampus.campus(identifier: campusIdentifier) { [weak self] result in
                switch result {
                case .success(let campus):
                    self?.mapView.setCampus(campus, animated: true, onCompletion: { (error) in
                        DispatchQueue.main.async {
                            self?.configureTableView()
                        }
                    })
                    
                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
        else {
            PWBuilding.building(identifier: buildingIdentifier) { [weak self] result in
                switch result {
                case .success(let building):
                    self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                        DispatchQueue.main.async {
                            self?.configureTableView()
                        }
                    })
                    
                case .failure(let error):
                    self?.warning(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureTableView() {
        guard let pois = mapView.pois() else {
            return
        }
        pointsOfInterest.append(contentsOf: pois)
        filteredPointsOfInterest = pointsOfInterest
        configureSearchController()
        tableView.isHidden = true
        tableView.register(POITableViewCell.self, forCellReuseIdentifier: poiCellReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        configureTableViewConstraints()
    }
    
    func configureTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Points of Interest"
        searchController.searchBar.delegate = self
    }
    
    func addFloorPickerView() {
        let bundleName = String(describing: FloorPickerView.self)
        let floorPickerView = Bundle.main.loadNibNamed(bundleName, owner: nil, options: nil)!.first as! FloorPickerView
        floorPickerView.configureInView(view, withMapView: mapView)
    }
}

// MARK: - UITableViewDataSource
extension SearchPOIViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPointsOfInterest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let poiCell = tableView.dequeueReusableCell(withIdentifier: poiCellReuseIdentifier, for: indexPath) as! POITableViewCell
        poiCell.configureSubviews()
        
        let pointOfInterest = filteredPointsOfInterest[indexPath.row]
        poiCell.poiImageView.image = pointOfInterest.image
        if campusIdentifier != 0 {
            if let floorName = pointOfInterest.floor?.name,
               let buildingName = pointOfInterest.floor?.building.name,
               let poiName = pointOfInterest.title {
                poiCell.titleLabel.text = "\(buildingName):: \(floorName):: \(poiName)"
            }
        }
        else {
            if let floorName = pointOfInterest.floor?.name,
               let poiName = pointOfInterest.title {
                poiCell.titleLabel.text = "\(floorName):: \(poiName)"
            }
        }
        return poiCell
    }
}

// MARK: - PWMapViewDelegate
extension SearchPOIViewController: PWMapViewDelegate {
    
    func mapView(_ mapView: PWMapView!, didChange floor: PWFloor!) {
        mapView.zoomToFitFloor(floor)
    }
}

// MARK: - UITableViewDelegate
extension SearchPOIViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.searchBar.endEditing(true)
        self.tableView.isHidden = true
        let pointOfInterest = filteredPointsOfInterest[indexPath.row]
        if mapView.currentFloor.floorID != pointOfInterest.floorID {
            let newFloor = mapView.floorById(pointOfInterest.floorID)
            mapView.currentFloor = newFloor
        }
        mapView.selectAnnotation(pointOfInterest, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchPOIViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else {
            filteredPointsOfInterest = pointsOfInterest
            tableView.reloadData()
            return
        }
        filteredPointsOfInterest = pointsOfInterest.filter({( pointOfInterest : PWPointOfInterest) -> Bool in
            guard let title = pointOfInterest.title else {
                return false
            }
            return title.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchPOIViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
}

// MARK: - Adjust for keyboard
extension SearchPOIViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
}

// MARK: - POITableViewCell
class POITableViewCell: UITableViewCell {
    
    var poiImageView: UIImageView!
    var titleLabel: UILabel!
    
    func configureSubviews() {
        if poiImageView != nil && titleLabel != nil {
            return
        }
        
        poiImageView = UIImageView()
        titleLabel = UILabel()
        
        poiImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(poiImageView)
        poiImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        poiImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        poiImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        poiImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: poiImageView.trailingAnchor, constant: 10.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0).isActive = true
    }
}
