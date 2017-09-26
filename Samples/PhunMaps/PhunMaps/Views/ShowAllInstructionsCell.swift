//
//  ShowAllInstructionsCell.swift
//  Mapping-Sample
//
//  Created on 6/22/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit

class ShowAllInstructionsCell: UITableViewCell {
    
    @IBOutlet weak var showAllStepsButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        showAllStepsButton.layer.cornerRadius = 15
        showAllStepsButton.clipsToBounds = true
        showAllStepsButton.backgroundColor = CommonSettings.buttonBackgroundColor
        showAllStepsButton.tintColor = UIColor.white
        showAllStepsButton.setTitle(NSLocalizedString("SHOW ALL STEPS", comment: ""), for: .normal)
    }
    
    func configureForShowStepsSelector(_ selector: Selector, _ target: Any) {
        showAllStepsButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
