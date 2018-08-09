//
//  POIDetailsViewController.swift
//  Mapping-Sample
//
//  Created on 6/13/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

class POIDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var directionsButton: UIButton!
    
    var pointOfInterest: PWPointOfInterest?
    var userLocation: PWUserLocation?
    var route: PWRoute?
    
    fileprivate var rowMapping = [rowMap]()
    
    enum rowMap: Int {
        case building
        case floor
        case type
        case coordinate
        case summary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 55
        
        configureRowMapping()
        
        directionsButton.layer.cornerRadius = 25
        directionsButton.clipsToBounds = true
        directionsButton.backgroundColor = CommonSettings.buttonBackgroundColor
        directionsButton.setTitle(NSLocalizedString("GET DIRECTIONS", comment: ""), for: .normal)
        directionsButton.addTarget(self, action: #selector(getDirectionsPressed(sender:)), for: .touchUpInside)
        
        directionsButton.isHidden = userLocation == nil
    }
    
    func configureRowMapping() {
        rowMapping.append(.building)
        rowMapping.append(.floor)
        rowMapping.append(.type)
        rowMapping.append(.coordinate)
        rowMapping.append(.summary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if let pointOfInterest = pointOfInterest {
            title = pointOfInterest.title
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func getDirectionsPressed(sender: UIButton) {
        guard let userLocation = userLocation, let pointOfInterest = pointOfInterest else {
            return
        }
        
        PWRoute.createRoute(from: userLocation, to: pointOfInterest, accessibility: false, excludedPoints: nil) { [weak self] (route, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if route == nil {
                let alertController = UIAlertController(title: NSLocalizedString("You have arrived!", comment: ""), message: NSLocalizedString("No route found because your location is too close to the destination", comment: ""), preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { [weak self] (action) in
                    self?.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(okayAction)
                
                self?.present(alertController, animated: true, completion: nil)
            }
            
            self?.route = route
            self?.performSegue(withIdentifier: String(describing: PreRoutingViewController.self), sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == String(describing: PreRoutingViewController.self), let destination = segue.destination as? PreRoutingViewController {
            destination.route = route
        }
    }
}

extension POIDetailsViewController: UITableViewDelegate { }

extension POIDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowMapping.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch rowMapping[indexPath.row] {
        case .building:
            if let detailsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: POIDetailsCell.self), for: indexPath) as? POIDetailsCell {
                detailsCell.titleLabel.text = NSLocalizedString("Building:", comment: "")
                
                if let buildingName = pointOfInterest?.floor.building.name {
                    detailsCell.detailLabel.text = buildingName
                }
                
                cell = detailsCell
            }
        case .floor:
            if let detailsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: POIDetailsCell.self), for: indexPath) as? POIDetailsCell {
                detailsCell.titleLabel.text = NSLocalizedString("Floor:", comment: "")
                if let floorName = pointOfInterest?.floor.name {
                    detailsCell.detailLabel.text = floorName
                }
                
                cell = detailsCell
            }
        case .type:
            if let detailsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: POIDetailsCell.self), for: indexPath) as? POIDetailsCell {
                detailsCell.titleLabel.text = NSLocalizedString("Type:", comment: "")
                if let poiTypeName = pointOfInterest?.pointOfInterestType.name {
                    detailsCell.detailLabel.text = poiTypeName
                }
                
                cell = detailsCell
            }
        case .coordinate:
            if let detailsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: POIDetailsCell.self), for: indexPath) as? POIDetailsCell {
                detailsCell.titleLabel.text = NSLocalizedString("Coordinate:", comment: "")
                if let pointOfInterest = pointOfInterest {
                    detailsCell.detailLabel.text = "\(pointOfInterest.coordinate.latitude), \(pointOfInterest.coordinate.longitude)"
                }
                
                cell = detailsCell
            }
        case .summary:
            if let detailsSummaryCell = tableView.dequeueReusableCell(withIdentifier: String(describing: POIDetailsSummaryCell.self), for: indexPath) as? POIDetailsSummaryCell {
                if let summary = pointOfInterest?.summary {
                    detailsSummaryCell.summaryLabel.text = summary
                }
                
                cell = detailsSummaryCell
            }
        }
        
        return cell
    }
}
