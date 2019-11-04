//
//  ArrivedManeuverViewModel.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 10/24/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import UIKit

struct ArrivedDirectionsViewModel {
    private let standardOptions: DirectionsTextOptions
    private let highlightOptions: DirectionsTextOptions
    
    private let destinationName: String?
    
    init(destinationName: String?,
        standardOptions: DirectionsTextOptions = .defaultStandardOptions,
         highlightOptions: DirectionsTextOptions = .defaultHighlightOptions) {
        self.destinationName = destinationName
        self.standardOptions = standardOptions
        self.highlightOptions = highlightOptions
    }
}

extension ArrivedDirectionsViewModel: DirectionsViewModel {
    var attributedText: NSAttributedString {
        let templateString = NSLocalizedString("$0 at $1", comment: "$0 = 'You have arrived', $1 = destination name")
        let youHaveArrivedString = NSLocalizedString("You have arrived", comment: "")
        
        let attributed = NSMutableAttributedString(string: templateString, attributes: standardOptions.attributes)
        attributed.replace(substring: "$0", with: youHaveArrivedString, attributes: highlightOptions.attributes)
        attributed.replace(substring: "$1", with: destinationDisplayName, attributes: standardOptions.attributes)
        
        return attributed
    }
    
    var image: UIImage {
        return #imageLiteral(resourceName: "RouteListInstructionArrived")
    }
    
    private var destinationDisplayName: String {
        if let destinationName = destinationName {
            return destinationName
        } else {
            return NSLocalizedString("your destination", comment: "")
        }
    }
}
