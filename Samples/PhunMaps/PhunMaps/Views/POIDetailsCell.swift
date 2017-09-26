//
//  POIDetailsCell.swift
//  Mapping-Sample
//
//  Created on 6/13/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit

class POIDetailsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        selectionStyle = .none
    }
}
