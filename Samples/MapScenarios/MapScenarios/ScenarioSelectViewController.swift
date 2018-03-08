//
//  ViewController.swift
//  MapScenarios
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import PWCore

class ScenarioSelectViewController: UITableViewController {
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    // These are universal across all view controllers but will be overridden by configured values in the individual controllers
    let universalApplicationId = ""
    let universalAccessKey = ""
    let universalSignatureKey = ""
    // Building identifier to be used in all view controllers, overridden when set in individual controllers
    let universalBuildingIdentifier = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if universalAccessKey.count > 0 && universalAccessKey.count > 0 && universalSignatureKey.count > 0 {
            PWCore.setApplicationID(universalApplicationId, accessKey: universalAccessKey, signatureKey: universalSignatureKey)
        }
        
        switch identifier {
        case String(describing: BluedotLocationViewController.self):
            if let bluedotLocationViewController = segue.destination as? BluedotLocationViewController {
                if bluedotLocationViewController.buildingIdentifier == 0 {
                    bluedotLocationViewController.buildingIdentifier = universalBuildingIdentifier
                }
            }
        case String(describing: LoadBuildingViewController.self):
            if let loadBuildingViewController = segue.destination as? LoadBuildingViewController {
                if loadBuildingViewController.buildingIdentifier == 0 {
                    loadBuildingViewController.buildingIdentifier = universalBuildingIdentifier
                }
            }
        case String(describing: LocationModesViewController.self):
            if let locationModesViewController = segue.destination as? LocationModesViewController {
                if locationModesViewController.buildingIdentifier == 0 {
                    locationModesViewController.buildingIdentifier = universalBuildingIdentifier
                }
            }
        case String(describing: CustomPOIViewController.self):
            if let customPOIViewController = segue.destination as? CustomPOIViewController {
                if customPOIViewController.buildingIdentifier == 0 {
                    customPOIViewController.buildingIdentifier = universalBuildingIdentifier
                }
            }
        case String(describing: RoutingViewController.self):
            if let routingViewController = segue.destination as? RoutingViewController {
                if routingViewController.buildingIdentifier == 0 {
                    routingViewController.buildingIdentifier = universalBuildingIdentifier
                }
            }
        case String(describing: SearchPOIViewController.self):
            if let searchPOIViewController = segue.destination as? SearchPOIViewController {
                if searchPOIViewController.buildingIdentifier == 0 {
                    searchPOIViewController.buildingIdentifier = universalBuildingIdentifier
                }
            }
        default:
            break
        }
    }
}

