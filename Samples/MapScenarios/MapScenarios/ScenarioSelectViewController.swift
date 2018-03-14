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
        
        switch identifier {
        case String(describing: BluedotLocationViewController.self):
            if let bluedotLocationViewController = segue.destination as? BluedotLocationViewController {
                if bluedotLocationViewController.buildingIdentifier == 0 {
                    bluedotLocationViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if bluedotLocationViewController.applicationId.count == 0 || bluedotLocationViewController.accessKey.count == 0 || bluedotLocationViewController.signatureKey.count == 0 {
                    bluedotLocationViewController.applicationId = universalApplicationId
                    bluedotLocationViewController.accessKey = universalAccessKey
                    bluedotLocationViewController.signatureKey = universalSignatureKey
                }
            }
        case String(describing: LoadBuildingViewController.self):
            if let loadBuildingViewController = segue.destination as? LoadBuildingViewController {
                if loadBuildingViewController.buildingIdentifier == 0 {
                    loadBuildingViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if loadBuildingViewController.applicationId.count == 0 || loadBuildingViewController.accessKey.count == 0 || loadBuildingViewController.signatureKey.count == 0 {
                    loadBuildingViewController.applicationId = universalApplicationId
                    loadBuildingViewController.accessKey = universalAccessKey
                    loadBuildingViewController.signatureKey = universalSignatureKey
                }
            }
        case String(describing: LocationModesViewController.self):
            if let locationModesViewController = segue.destination as? LocationModesViewController {
                if locationModesViewController.buildingIdentifier == 0 {
                    locationModesViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if locationModesViewController.applicationId.count == 0 || locationModesViewController.accessKey.count == 0 || locationModesViewController.signatureKey.count == 0 {
                    locationModesViewController.applicationId = universalApplicationId
                    locationModesViewController.accessKey = universalAccessKey
                    locationModesViewController.signatureKey = universalSignatureKey
                }
            }
        case String(describing: CustomPOIViewController.self):
            if let customPOIViewController = segue.destination as? CustomPOIViewController {
                if customPOIViewController.buildingIdentifier == 0 {
                    customPOIViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if customPOIViewController.applicationId.count == 0 || customPOIViewController.accessKey.count == 0 || customPOIViewController.signatureKey.count == 0 {
                    customPOIViewController.applicationId = universalApplicationId
                    customPOIViewController.accessKey = universalAccessKey
                    customPOIViewController.signatureKey = universalSignatureKey
                }
            }
        case String(describing: RoutingViewController.self):
            if let routingViewController = segue.destination as? RoutingViewController {
                if routingViewController.buildingIdentifier == 0 {
                    routingViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if routingViewController.applicationId.count == 0 || routingViewController.accessKey.count == 0 || routingViewController.signatureKey.count == 0 {
                    routingViewController.applicationId = universalApplicationId
                    routingViewController.accessKey = universalAccessKey
                    routingViewController.signatureKey = universalSignatureKey
                }
            }
        case String(describing: SearchPOIViewController.self):
            if let searchPOIViewController = segue.destination as? SearchPOIViewController {
                if searchPOIViewController.buildingIdentifier == 0 {
                    searchPOIViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if searchPOIViewController.applicationId.count == 0 || searchPOIViewController.accessKey.count == 0 || searchPOIViewController.signatureKey.count == 0 {
                    searchPOIViewController.applicationId = universalApplicationId
                    searchPOIViewController.accessKey = universalAccessKey
                    searchPOIViewController.signatureKey = universalSignatureKey
                }
            }
        case String(describing: LocationSharingViewController.self):
            if let locationSharingViewController = segue.destination as? LocationSharingViewController {
                if locationSharingViewController.buildingIdentifier == 0 {
                    locationSharingViewController.buildingIdentifier = universalBuildingIdentifier
                }
                if locationSharingViewController.applicationId.count == 0 || locationSharingViewController.accessKey.count == 0 || locationSharingViewController.signatureKey.count == 0 {
                    locationSharingViewController.applicationId = universalApplicationId
                    locationSharingViewController.accessKey = universalAccessKey
                    locationSharingViewController.signatureKey = universalSignatureKey
                }
            }
        default:
            break
        }
    }
}

