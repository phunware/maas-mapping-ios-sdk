//
//  WalkTimeView.swift
//  MapScenarios
//
//  Created on 2/21/19.
//  Copyright © 2019 Patrick Dunshee. All rights reserved.
//

import UIKit
import CoreLocation

extension Notification.Name {
    static let ExitWalkTimeButtonTapped = NSNotification.Name("ExitWalkTimeButtonTapped")
}

extension Collection where Element: Numeric {
    // Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    // Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(total) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    // Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

class WalkTimeView: UIView {
    
    // Supposed average walk speed 0.7 meter per second
    var averageWalkSpeed: Double = 0.7
    
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var cancelRouteButton: UIButton!
    
    @IBAction func cancelRouteButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .ExitWalkTimeButtonTapped, object: nil)
    }
    
    func updateWalkTime(distance: CLLocationDistance, averageSpeed: CLLocationSpeed) {
        if distance == 0 {
            restTimeLabel.text = ""
            arriveTimeLabel.text = "Arrived"
        }
        
        // Set initial value
        if averageSpeed > 0 {
            averageWalkSpeed = averageSpeed
        }
        let duration = estimatedTime(distance: distance)
        let arriveTime = Date().addingTimeInterval(duration)
        
        isHidden = false
        restTimeLabel.text = format(duration: duration)
        arriveTimeLabel.text = "Arrive Time \(format(date: arriveTime))"
    }
}

// MARK: - Helpers

extension WalkTimeView {
    
    // Calculate the walk time
    func estimatedTime(distance: CLLocationDistance) -> TimeInterval {
        let duration =  distance / averageWalkSpeed
        return duration
    }
    
    // Format walk time
    func format(duration: TimeInterval) -> String {
        if duration < 60 {
            return "1min"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: duration)!
    }
    
    // Format arrive time
    func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from:date)
    }
}
