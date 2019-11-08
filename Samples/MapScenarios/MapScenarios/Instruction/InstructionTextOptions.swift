//
//  InstructionTextOptions.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/18/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit

struct InstructionTextOptions {
    let color: UIColor
    let font: UIFont
    
    var attributes: [NSAttributedString.Key : Any] {
        return [.foregroundColor: color, .font: font]
    }
}

extension InstructionTextOptions {
    static let defaultStandardOptions: InstructionTextOptions = {
        if #available(iOS 13, *) {
            return InstructionTextOptions(color: .label, font: .systemFont(ofSize: 15.0, weight: .regular))
        } else {
            return InstructionTextOptions(color: .darkText, font: .systemFont(ofSize: 15.0, weight: .regular))
        }
    }()
    
    static let defaultHighlightOptions = InstructionTextOptions(color: .systemBlue, font: .systemFont(ofSize: 15.0, weight: .bold))
}
