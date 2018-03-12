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
import Kingfisher

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

class SearchPOIViewController: UIViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    let applicationId = ""
    let accessKey = ""
    let signatureKey = ""
    
    var buildingIdentifier = 0 // Enter your building identifier here, found on the building's Edit page on Maas portal
    
    let mapView = PWMapView()
    
    // Search view
    let tableView = UITableView()
    let poiCellReuseIdentifier = "POICell"
    var sortedPointsOfInterest = [PWPointOfInterest]()
    var filteredPointsOfInterest = [PWPointOfInterest]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search for Point of Interest"
        
        if applicationId.count > 0 && accessKey.count > 0 && signatureKey.count > 0 {
            PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                DispatchQueue.main.async {
                    self?.configureTableView()
                }
            })
        }
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
        if let sortedPoints = mapView.building.pois.sorted(by: {
            if let poi1 = $0 as? PWPointOfInterest, let poi2 = $1 as? PWPointOfInterest {
                return poi1.title < poi2.title
            }
            return false
        }) as? [PWPointOfInterest] {
            sortedPointsOfInterest = sortedPoints
            filteredPointsOfInterest = sortedPointsOfInterest
        }
        configureSearchController()
        tableView.isHidden = true
        tableView.register(POITableViewCell.self, forCellReuseIdentifier: poiCellReuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
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
        definesPresentationContext = true
        navigationItem.searchController = searchController
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
        if let imageURL = pointOfInterest.imageURL {
            poiCell.poiImageView.kf.indicatorType = .activity
            poiCell.poiImageView.kf.setImage(with: imageURL)
        }
        poiCell.titleLabel.text = pointOfInterest.title
        return poiCell
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
            let newFloor = mapView.building.floor(byId: pointOfInterest.floorID)
            mapView.currentFloor = newFloor
        }
        mapView.selectAnnotation(pointOfInterest, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchPOIViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else {
            filteredPointsOfInterest = sortedPointsOfInterest
            tableView.reloadData()
            return
        }
        filteredPointsOfInterest = sortedPointsOfInterest.filter({( pointOfInterest : PWPointOfInterest) -> Bool in
            return pointOfInterest.title.lowercased().contains(searchText.lowercased())
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
}
