//
//  CLLocationDistance+Localization.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/21/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    static let feetPerMeter: CLLocationDistance = 3.28084
    
    var localizedDistanceInSmallUnits: String {
        let usesMetricSystem = NSLocale.current.usesMetricSystem
        
        let convertedDistance = usesMetricSystem
            ? self
            : self * CLLocationDistance.feetPerMeter
        
        let roundedDistance = Int(Darwin.round(convertedDistance))
        
        let suffix: String
        
        if roundedDistance == 1 {
            suffix = usesMetricSystem ? NSLocalizedString("meter", comment: "") : NSLocalizedString("foot", comment: "")
        } else {
            suffix = usesMetricSystem ? NSLocalizedString("meters", comment: "") : NSLocalizedString("feet", comment: "")
        }
        
        return "\(roundedDistance) \(suffix)"
    }
}
