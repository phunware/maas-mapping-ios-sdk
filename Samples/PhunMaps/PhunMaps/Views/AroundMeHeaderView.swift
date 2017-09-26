//
//  AroundMeHeaderView.swift
//  Mapping-Sample
//
//  Created on 9/22/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit

class AroundMeHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var currentlyAtLabel: UILabel!
    @IBOutlet weak var nearestPOILabel: UILabel!
    @IBOutlet weak var followingAreWithinLabel: UILabel!
    @IBOutlet weak var followingAreWithinContainerHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
    }
}
