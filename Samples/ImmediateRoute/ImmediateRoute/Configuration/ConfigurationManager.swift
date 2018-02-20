//
//  ConfigurationManager.swift
//  PhunMaps
//
//  Created on 4/24/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import PWCore

class ConfigurationManager {
    
    static let shared = ConfigurationManager()
    
    var configurations: [BuildingAppConfiguration]!
    var currentConfiguration: BuildingAppConfiguration!
    
    private lazy var defaultConfiguration: BuildingAppConfiguration? = {
        if let path = Bundle.main.path(forResource: "DefaultConfiguration", ofType: "plist"), let defaultConfigDict = NSDictionary(contentsOfFile: path) as? [String : AnyObject] {
            let configuration = BuildingAppConfiguration(dictionary: defaultConfigDict)
            
            return configuration
        }
        
        return nil
    }()
    
    private init() {
        if let defaultConfiguration = defaultConfiguration {
            currentConfiguration = defaultConfiguration
            configurations = [defaultConfiguration]
        } else {
            print("Unable to load any configuration. Please check the DefaultConfiguration.plist for syntax")
            fatalError()
        }
    }
    
    func configure() {
        // Put any app configuration logic here
        PWCore.setApplicationID(currentConfiguration.appId, accessKey: currentConfiguration.accessKey, signatureKey: currentConfiguration.signatureKey)
    }
}
