//
//  MapFloorSelectionViewController.swift
//  Mapping-Sample
//
//  Created on 8/14/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class MapFloorSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mapView: PWMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select floor", comment: "")
        
        navigationController?.navigationBar.barTintColor = CommonSettings.navigationBarBackgroundColor
        navigationController?.navigationBar.tintColor = CommonSettings.navigationBarForegroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : CommonSettings.viewForegroundColor]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close(barButtonItem:)))
    }
    
    @objc func close(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension MapFloorSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let floor = mapView.building.floors[indexPath.row]
        
        mapView.currentFloor = floor
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension MapFloorSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard mapView.building != nil else {
            return 0
        }
        return mapView.building.floors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapFloorCell", for: indexPath)
        let floor = mapView.building.floors[indexPath.row]
        
        cell.textLabel?.text = floor.name
        
        if floor == mapView.currentFloor {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
