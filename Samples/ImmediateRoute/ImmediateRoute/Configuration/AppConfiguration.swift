//
//  AppConfiguration.swift
//  CoreSample
//
//  Created on 4/24/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import PWLocation
import PWMapKit

enum FBProviderType {
    case cmx
    case managed
    case senion
}

protocol AppConfiguration: class, Equatable {
    
    var appId: String! { get set }
    var accessKey: String! { get set }
    var signatureKey: String! { get set }
}

class BuildingAppConfiguration: NSObject, AppConfiguration {
    
    var appId: String!
    var accessKey: String!
    var signatureKey: String!
    var buildingId: Int!
    
    var managedLocationManager: PWManagedLocationManager?
    var name: String?
    
    var loadedBuilding: PWBuilding?
    
    init(dictionary: [String : AnyObject]) {
        let maasConfigurationDictionary = dictionary["ios"] as! [String : AnyObject]
        appId = String(describing: maasConfigurationDictionary["appId"]!)
        accessKey = String(describing: maasConfigurationDictionary["accessKey"]!)
        signatureKey = String(describing: maasConfigurationDictionary["signatureKey"]!)
        buildingId = dictionary["buildingId"]! as! Int
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
    }
    
    static func ==(lhs: BuildingAppConfiguration, rhs: BuildingAppConfiguration) -> Bool {
        return lhs.appId == rhs.appId && lhs.accessKey == rhs.accessKey && lhs.signatureKey == rhs.signatureKey && lhs.buildingId == rhs.buildingId
    }
}
