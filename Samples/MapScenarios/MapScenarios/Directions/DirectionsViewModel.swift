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

// MARK: - Notes
// DirectionsViewModel is used to encapsulate the presentation of route instructions.
// It doesn't contain any application/business logic, only presentation logic for displaying
// route instructions, usually in a table view/collection view cell.

protocol DirectionsViewModel {
    var attributedText: NSAttributedString { get }
    var image: UIImage { get }
}

extension DirectionsViewModel {
    // convenience method to strip the attributed text of it's attributes, providing a plain string
    var text: String {
        return attributedText.string
    }
}
