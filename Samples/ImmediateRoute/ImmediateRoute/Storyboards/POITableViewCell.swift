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
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func setPointOfInterest(poi: PWPointOfInterest) {
		if let image = poi.image {
			self.imageView?.image = image
			
			let size = CGSize(width: CommonSettingsConstants.UI.standardIconSize, height: CommonSettingsConstants.UI.standardIconSize)
			UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
			let imageRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
			self.imageView?.image?.draw(in: imageRect)
			self.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
		}
		
		if let title = poi.title {
			self.textLabel?.text = title
		}
		
		if let floorName = poi.floor.name {
			self.detailTextLabel?.text = floorName
		}
	}
}
