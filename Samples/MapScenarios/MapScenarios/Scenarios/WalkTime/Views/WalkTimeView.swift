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

class WalkTimeView: UIView {
    
    // Supposed average walk speed 0.7 meter per second
    let averageWalkSpeed = 0.7
    
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var cancelRouteButton: UIButton!
    
    @IBAction func cancelRouteButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .ExitWalkTimeButtonTapped, object: nil)
    }
    
    func updateWalkTime(distance: CLLocationDistance) {
        // Set initial value
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
