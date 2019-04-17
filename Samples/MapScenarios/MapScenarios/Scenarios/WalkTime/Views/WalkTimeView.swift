//
//  WalkTimeView.swift
//  MapScenarios
//
//  Created on 2/21/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import UIKit
import CoreLocation

extension Notification.Name {
    static let ExitWalkTimeButtonTapped = NSNotification.Name("ExitWalkTimeButtonTapped")
    static let WalkTimeChanged = NSNotification.Name("WalkTimeChanged")
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

struct NotificationUserInfoKeys {
    static let remainingDistance = "distance"
    static let averageSpeed = "speed"
}

class WalkTimeView: UIView {
    // View height
    static let defaultHeight: CGFloat = 80.0
    // Supposed average walk speed is 0.7 m/s
    var averageWalkSpeed: Double = 0.7
    // The reasonable walk speed range
    var averageWalkSpeedRange: Range = 0.2..<1.5
    // Remaining distance
    var remainingDistance: CLLocationDistance!
    // Average speed
    var averageSpeed: CLLocationSpeed!
    
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var cancelRouteButton: UIButton!
    
    @IBAction func cancelRouteButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .ExitWalkTimeButtonTapped, object: nil)
    }
    
    func updateWalkTime(distance: CLLocationDistance, averageSpeed: CLLocationSpeed = 0.7) {
        DispatchQueue.main.async {
            if distance == 0 {
                self.restTimeLabel.text = ""
                self.arriveTimeLabel.text = "Arrived"
            }
            
            // Set initial value
            if self.averageWalkSpeedRange.contains(averageSpeed) {
                self.averageWalkSpeed = averageSpeed
            }
            let duration = self.estimatedTime(distance: distance)
            let arriveTime = Date().addingTimeInterval(duration)
            
            self.isHidden = false
            self.restTimeLabel.text = self.format(duration: duration)
            self.arriveTimeLabel.text = "Arrival Time \(self.format(date: arriveTime))"
        }
        self.remainingDistance = distance
        self.averageSpeed = averageSpeed
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
        let durationInMinutes = Int(ceil((duration / 60.0)))
        return "\(durationInMinutes) min"
    }
    
    // Format arrival time
    func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from:date)
    }
}
