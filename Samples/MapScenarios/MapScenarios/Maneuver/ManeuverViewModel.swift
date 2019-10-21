//
//  ManeuverViewModel.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol ManeuverViewModel {
    var attributedText: NSAttributedString { get }
    var image: UIImage { get }
}

extension ManeuverViewModel {
    var text: String {
        return attributedText.string
    }
}
