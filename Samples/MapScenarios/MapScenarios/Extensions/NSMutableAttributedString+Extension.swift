//
//  NSMutableAttributedString+Extension.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/21/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func replace(substring: String, with replacement: String, attributes: [NSAttributedString.Key : Any]) {
        if let range = self.string.range(of: substring) {
            let nsRange = NSRange(range, in: self.string)
            let replacement = NSAttributedString(string: replacement, attributes: attributes)
            self.replaceCharacters(in: nsRange, with: replacement)
        }
    }
}
