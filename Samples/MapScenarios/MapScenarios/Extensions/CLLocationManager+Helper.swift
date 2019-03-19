//
//  CLLocationManager+Helper.swift
//  MapScenarios
//
//  Created on 3/19/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import CoreLocation

extension CLLocationManager {
    
    class func isAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
}
