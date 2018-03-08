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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search for Point of Interest"
        
        if applicationId.count > 0 && accessKey.count > 0 && signatureKey.count > 0 {
            PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        }
        
        view.addSubview(mapView)
        configureMapViewConstraints()
        
        PWBuilding.building(withIdentifier: buildingIdentifier) { [weak self] (building, error) in
            self?.mapView.setBuilding(building, animated: true, onCompletion: { (error) in
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.configureTableView()
                        strongSelf.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: strongSelf, action: #selector(strongSelf.searchTapped))
                    }
                }
            })
        }
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
        }
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
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func searchTapped() {
        tableView.isHidden = !tableView.isHidden
    }
}

// MARK: - UITableViewDataSource

extension SearchPOIViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPointsOfInterest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let poiCell = tableView.dequeueReusableCell(withIdentifier: poiCellReuseIdentifier, for: indexPath) as! POITableViewCell
        poiCell.configureSubviews()
        
        let pointOfInterest = sortedPointsOfInterest[indexPath.row]
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
        self.tableView.isHidden = true
        let pointOfInterest = sortedPointsOfInterest[indexPath.row]
        if mapView.currentFloor.floorID != pointOfInterest.floorID {
            let newFloor = mapView.building.floor(byId: pointOfInterest.floorID)
            mapView.currentFloor = newFloor
        }
        mapView.selectAnnotation(pointOfInterest, animated: true)
    }
}

