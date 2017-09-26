//
//  CommonSettings.swift
//  Maps-Samples
//
//  Created on 5/31/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import PWMapKit

struct CommonSettingsConstants {
    struct UI {
        static let standardIconSize = 32.0
        static let standardSpace = 10.0
        static let standardLineSpace = 5.0
        static let horizontalOffset = 15.0
        static let verticalOffset = 15.0
        static let viewRefreshInterval = 2
    }
    struct Distance {
        static let defaultSearchRadius = 25
        static let filterDistances = [10, 15, 20, 25, 30, 35, 40, 45, 50]
    }
}

class PWAlertAction: UIAlertAction {

    var carrier: Any?
}

class CommonSettings {

    // MARK: - Colors
    static let navigationBarBackgroundColor = UIColor(red: 0.0118, green: 0.3961, blue: 0.7529, alpha: 1.0)
    static let navigationBarForegroundColor = UIColor.white
    static let viewForegroundColor = UIColor.white
    static let buttonContainerBackgroundColor = UIColor(red: 0.9608, green: 0.8275, blue: 0.1569, alpha: 1.0)
    static let buttonBackgroundColor = UIColor(red: 0.7647, green: 0.5922, blue: 0.1020, alpha: 1.0)
    static let toolbarColor = UIColor(red: 20.0 / 255.0, green: 93.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    
    // MARK: - Distance Helpers
    class func distanceFrom(_ start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> CLLocationDistance {
        let startLocation = CLLocation.init(latitude: start.latitude, longitude: start.longitude)
        let endLocation = CLLocation.init(latitude: end.latitude, longitude: end.longitude)
        return startLocation.distance(from: endLocation)
    }
    
    class func distanceString(from distance: CLLocationDistance) -> String {
        let distanceInt = Int(round(distance))
        if distanceInt != 1 {
            return String(format: NSLocalizedString("%@ meters", comment: ""), "\(distanceInt)")
        } else {
            return String(format: NSLocalizedString("%@ meter", comment: ""), "\(distanceInt)")
        }
    }
    
    class func feetFromMeters(_ meter: Double) -> Double {
        return meter * 3.28084 // 3.28084 feet in a meter
    }
    
    class func metersFromFeet(_ feet: Double) -> Double {
        return feet * 0.3048 // 0.3048 meters in a foot
    }
    
    // MARK: - Images
    class func imageFromDirection(_ direction: PWRouteInstructionDirection) -> UIImage {
        switch direction {
        case .straight:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
        case .left:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionSharpLeft")
        case .right:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionSharpRight")
        case .bearLeft:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionBearLeft")
        case .bearRight:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionBearRight")
        case .elevatorUp:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorUp")
        case .elevatorDown:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionElevatorDown")
        case .stairsUp:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsUp")
        case .stairsDown:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStairsDown")
        default:
            return #imageLiteral(resourceName: "PWRouteInstructionDirectionStraight")
        }
    }
    
    class func imageFromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - Constraint Helper
    class func changeConstraintsForAttribute(_ attribute: NSLayoutAttribute, to value: CGFloat, on view: UIView) {
        if let constraints = view.superview?.constraints {
            for constraint: NSLayoutConstraint in constraints {
                if constraint.firstAttribute == attribute {
                    constraint.constant = value
                    view.layoutIfNeeded()
                }
            }
        }
        
    }
    
    class func buildActionSheetWithItems(_ items: [AnyObject], displayProperty: String?, selectedItem: AnyObject?, title: String, actionNameFormat: String?, topAction: String?, selectAction: ((_ selection: Any?) -> Void)?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        if var topActionTitle = topAction {
            if selectedItem == nil {
                topActionTitle = "✔︎ \(topActionTitle)"
            }
            let action = PWAlertAction(title: topActionTitle, style: UIAlertActionStyle.default, handler: { action in
                selectAction?(nil)
            })
            action.carrier = nil
            alert.addAction(action)
        }
        
        for item in items {
            var actionTitle = item.stringValue
            var currentValue = selectedItem?.stringValue
            if let displayProperty = displayProperty {
                actionTitle = item.value(forKey: displayProperty) as? String
                currentValue = selectedItem?.value(forKey: displayProperty) as? String
            }
            
            let isMatch = doesActionTitle(actionTitle as AnyObject, match: currentValue! as AnyObject)
            
            if let actionNameFormat = actionNameFormat {
                actionTitle = String.init(format: actionNameFormat, actionTitle!)
            }
            
            if isMatch {
                actionTitle = "✔︎ \(actionTitle!)"
            }
            
            let action = PWAlertAction(title: actionTitle!, style: UIAlertActionStyle.default, handler: { action in
                selectAction?((action as! PWAlertAction).carrier)
            })
            
            action.carrier = item
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(withComment: "Cancel"), style: .cancel, handler: nil))
        
        return alert
    }
    
    private class func doesActionTitle(_ actionTitle: AnyObject, match currentValue: AnyObject) -> Bool {
        var isMatch = false
        if let actionTitle = actionTitle as? String {
            isMatch = actionTitle == currentValue as! String
        } else {
            isMatch = actionTitle.isEqual(currentValue)
        }
        return isMatch
    }
}

// MARK: - Localization

extension String {
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}
