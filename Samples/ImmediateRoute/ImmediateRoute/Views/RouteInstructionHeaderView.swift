//
//  RouteInstructionHeaderView.swift
//  Mapping-Sample
//
//  Created on 8/10/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class RouteInstructionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var navigatingToLabel: UILabel!
    @IBOutlet weak var destinationPointOfInterestLabel: UILabel!
    @IBOutlet weak var destinationFloorLabel: UILabel!
    @IBOutlet weak var orientationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        navigatingToLabel.text = NSLocalizedString("NAVIGATING TO:", comment: "")
        accessibilityElements = [orientationLabel]
    }
    
    func configureWith(route: PWRoute?) {
        orientationLabel.text = NSLocalizedString("Trying to detect your orientation.", comment: "")
        guard let route = route else {
            destinationPointOfInterestLabel.text = NSLocalizedString("Unknown", comment: "")
            destinationFloorLabel.text = NSLocalizedString("Unknown floor", comment: "")
            return
        }
        destinationPointOfInterestLabel.text = route.endPoint.title ?? NSLocalizedString("Unknown", comment: "")
        if let destinationFloor = route.building.floor(byId: route.endPoint.floorID) {
            destinationFloorLabel.text = destinationFloor.name
        } else {
            destinationFloorLabel.text = NSLocalizedString("Unknown floor", comment: "")
        }
    }
}
