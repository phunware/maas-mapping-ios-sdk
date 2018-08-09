//
//  RouteSummaryCell.swift
//  Mapping-Sample
//
//  Created on 6/16/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class RouteSummaryCell: UITableViewCell {
    
    @IBOutlet weak var routeSummaryLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = CommonSettings.navigationBarBackgroundColor
    }
    
    override func awakeFromNib() {
        routeSummaryLabel.textColor = .white
    }
    
    func configureForRoute(_ route: PWRoute) {
        var keyArray = [String]()
        var valueArray = [String]()
        
        let startPointFloor = route.building.floor(byId: route.startPoint.floorID)
        let endPointFloor = route.building.floor(byId: route.endPoint.floorID)
        
        keyArray.append(NSLocalizedString("Currently On", comment: ""))
        valueArray.append((startPointFloor?.name ?? NSLocalizedString("Unknown", comment: "")))
        keyArray.append(NSLocalizedString("Will navigate you to", comment: ""))
        valueArray.append((endPointFloor?.name ?? NSLocalizedString("Unknown", comment: "")))
        
        let estimatedTimeString = "\(Int(ceil(Double(route.estimatedTime))))"
        var travelTimeString = String(format: NSLocalizedString("%@ minutes", comment: ""), estimatedTimeString)
        if estimatedTimeString == "1" {
            travelTimeString = String(format: NSLocalizedString("%@ minute", comment: ""), "\(route.estimatedTime)")
        }
        keyArray.append(NSLocalizedString("Approximate travel time is", comment: ""))
        valueArray.append(travelTimeString)
        
        keyArray.append(NSLocalizedString("Going", comment: ""))
        valueArray.append(CommonSettings.distanceString(from: CLLocationDistance(route.distance)))
        
        let floorDifference = abs((startPointFloor?.level)! - (endPointFloor?.level)!)
        var floorDifferenceString = String(format: NSLocalizedString("%@ floors", comment: ""), "\(floorDifference)")
        if floorDifference == 1 {
            floorDifferenceString = String(format: NSLocalizedString("%@ floor", comment: ""), "\(floorDifference)")
        }
        keyArray.append(NSLocalizedString("Past", comment: ""))
        valueArray.append(floorDifferenceString)
        
        let attributedString = formattedString(keys: keyArray, values: valueArray)
        
        routeSummaryLabel.attributedText = attributedString
    }
    
    func formattedString(keys keyArray: [String], values valueArray: [String]) -> NSAttributedString {
        let keyTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18.0)]
        let valueTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18.0)]
        let newlineAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14.0)]
        let newlineAttributedString = NSAttributedString(string: "\n", attributes: newlineAttributes)
        
        let formattedString = NSMutableAttributedString()
        for (index, key) in keyArray.enumerated() {
            let value = valueArray[index]
            formattedString.append(NSAttributedString(string: key, attributes: keyTextAttributes))
            formattedString.append(newlineAttributedString)
            formattedString.append(NSAttributedString(string: value, attributes: valueTextAttributes))
            if index != keyArray.count - 1 {
                formattedString.append(newlineAttributedString)
                formattedString.append(newlineAttributedString)
            }
        }
        
        return formattedString.copy() as! NSAttributedString
    }
}
