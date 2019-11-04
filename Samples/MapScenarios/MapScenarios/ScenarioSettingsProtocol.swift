//
//  ScenarioCredentialsProtocol.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/30/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit

protocol ScenarioSettingsProtocol {
    var applicationId: String { get set }
    var accessKey: String { get set }
    var signatureKey: String { get set }
    var buildingIdentifier: Int { get set }
}

extension ScenarioSettingsProtocol where Self: UIViewController {
    func validateScenarioSettings() -> Bool {
        if applicationId.isEmpty || accessKey.isEmpty || signatureKey.isEmpty || buildingIdentifier == 0 {
            let alertVC = UIAlertController(title: "Code Update Required", message: "Please put your applicationId/accessKey/signatureKey and buildingId in ScenarioSelectViewController.swift or the related view controllers.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
}
