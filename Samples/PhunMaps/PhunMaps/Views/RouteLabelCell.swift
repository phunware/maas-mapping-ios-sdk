//
//  RouteLabelCell.swift
//  Mapping-Sample
//
//  Created on 6/20/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit

class RouteLabelCell: UITableViewCell {
    
    @IBOutlet weak var routeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        routeLabel.text = NSLocalizedString("Route:", comment: "")
    }
}
