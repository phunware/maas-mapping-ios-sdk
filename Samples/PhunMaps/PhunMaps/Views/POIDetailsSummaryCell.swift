//
//  POIDetailsSummaryCell.swift
//  Mapping-Sample
//
//  Created on 6/13/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit

class POIDetailsSummaryCell: UITableViewCell {
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        selectionStyle = .none
    }
}
