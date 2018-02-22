//
//  SharedLocationAnnotation.swift
//  LocationSharing
//
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import MapKit
import PWMapKit

class SharedLocationAnnotation: MKPointAnnotation {
    
    var sharedLocation: PWSharedLocation!
    
    init(sharedLocation: PWSharedLocation) {
        super.init()
        self.sharedLocation = sharedLocation
    }
    
}
