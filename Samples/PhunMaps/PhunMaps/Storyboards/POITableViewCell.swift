//
//  POITableViewCell.swift
//  Mapping-Sample
//
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

let POICellIdentifier = "POICellIdentifier"

class POITableViewCell: UITableViewCell {
	
    @IBOutlet weak var poiImageView: UIImageView!
    @IBOutlet weak var poiTitleLabel: UILabel!
    @IBOutlet weak var poiDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func setPointOfInterest(poi: PWPointOfInterest) {
        poiImageView.image = poi.image
        
        if let title = poi.title {
            self.poiTitleLabel?.text = title
        }

        if let floorName = poi.floor?.name {
            self.poiDetailLabel?.text = floorName
        }
	}
}
