//
//  ManeuverPresenterTextOptions.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit

struct ManeuverPresenterTextOptions {
    let color: UIColor
    let font: UIFont
    
    var attributes: [NSAttributedString.Key : Any] {
        return [.foregroundColor: color, .font: font]
    }
}

extension ManeuverPresenterTextOptions {
    static let defaultStandardOptions = ManeuverPresenterTextOptions(color: .darkText,
                                                                     font: .systemFont(ofSize: 15.0, weight: .regular))
    
    static let defaultHighlightOptions = ManeuverPresenterTextOptions(color: .nasa,
                                                                      font: .systemFont(ofSize: 15.0, weight: .bold))
}
