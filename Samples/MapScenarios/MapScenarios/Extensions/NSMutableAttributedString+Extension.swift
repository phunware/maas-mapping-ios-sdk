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
    
    var lastAttributes: [NSAttributedString.Key : Any]? {
        var last: [NSAttributedString.Key : Any]? = nil

        enumerateAttributes(in: .init(location: 0, length: length), options: .reverse) { (attributes, range, stop) in
            last = attributes
            stop.pointee = true
        }
        
        return last
    }
}
