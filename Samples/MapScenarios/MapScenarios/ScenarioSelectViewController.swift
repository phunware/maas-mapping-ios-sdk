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
        navigationController?.navigationBar.barTintColor = .darkerGray
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
        // putting an invisible view as the footer view will hide the empty table view rows after the last valid one
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var scenarioController = segue.destination as? ScenarioSettingsProtocol {
            if scenarioController.applicationId.isEmpty {
                scenarioController.applicationId = universalApplicationId
            }
            
            if scenarioController.accessKey.isEmpty {
                scenarioController.accessKey = universalAccessKey
            }
            
            if scenarioController.signatureKey.isEmpty {
                scenarioController.signatureKey = universalSignatureKey
            }
            
            if scenarioController.buildingIdentifier == 0 {
                scenarioController.buildingIdentifier = universalBuildingIdentifier
            }
        }
    }
}

extension UIViewController {

    func warning(_ message: String, file: String = #file) {
        let fileName = file.split(separator: "/").last ?? "Unknown file"
        let alertVC = UIAlertController(title: "Warning", message: fileName + ": " + message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }    
}
