//
//  POITableViewCell.swift
//  LocationDiagnosticSwift
//
//  Created by Patrick Dunshee on 8/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class RoutePOITableViewCell: UITableViewCell {
    
    @IBOutlet weak var poiImageView: UIImageView!
    @IBOutlet weak var poiTitleLabel: UILabel!
    @IBOutlet weak var poiDetailLabel: UILabel!
    
    func setPointOfInterest(poi: PointOfInterest) {
        poiImageView.image = poi.poiImage
        
        if let title = poi.poiTitle {
            self.poiTitleLabel?.text = title
        }
        
        if let floorName = poi.poiFloor.name {
            self.poiDetailLabel?.text = floorName
        }
    }
}
