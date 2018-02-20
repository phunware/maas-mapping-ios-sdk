//
//  ToolbarController.swift
//  Mapping-Sample
//
//  Created on 7/18/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit

class ToolbarView: UIToolbar {
    
    let flexibleBarSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        barTintColor = CommonSettings.navigationBarBackgroundColor
        tintColor = CommonSettings.navigationBarForegroundColor
    }
}
