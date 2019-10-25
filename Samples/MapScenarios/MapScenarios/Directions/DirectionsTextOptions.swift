//
//  DirectionsTextOptions.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit

struct DirectionsTextOptions {
    let color: UIColor
    let font: UIFont
    
    var attributes: [NSAttributedString.Key : Any] {
        return [.foregroundColor: color, .font: font]
    }
}

extension DirectionsTextOptions {
    static let defaultStandardOptions = DirectionsTextOptions(color: .darkText,
                                                                     font: .systemFont(ofSize: 15.0, weight: .regular))
    
    static let defaultHighlightOptions = DirectionsTextOptions(color: .nasa,
                                                                      font: .systemFont(ofSize: 15.0, weight: .bold))
}
