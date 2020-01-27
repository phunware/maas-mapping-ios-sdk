//
//  WalkTimeView.swift
//  MapScenarios
//
//  Created on 2/21/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import UIKit
import CoreLocation

protocol WalkTimeViewDelegate: class {
    func exitButtonPressed(for walkTimeView: WalkTimeView)
}

class WalkTimeView: UIView {
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var cancelRouteButton: UIButton!
    
    // Delegate
    weak var delegate: WalkTimeViewDelegate?
    
    // View height
    static let defaultHeight: CGFloat = 80.0
    
    // Supposed average walk speed is 0.7 m/s
    var averageWalkSpeed: Double = 0.7
    
    // The reasonable walk speed range
    var averageWalkSpeedRange: Range = 0.2..<1.5
    
    // Remaining distance
    var remainingDistance: CLLocationDistance = 0
    
    // Average speed
    var averageSpeed: CLLocationSpeed = 0
    
    @IBAction func cancelRouteButtonTapped(_ sender: UIButton) {
        delegate?.exitButtonPressed(for: self)
        
    }
    
    func updateWalkTime(distance: CLLocationDistance, averageSpeed: CLLocationSpeed = 0.7) {
        if distance == 0 {
            self.restTimeLabel.text = ""
            self.arriveTimeLabel.text = NSLocalizedString("Arrived", comment: "")
        }
        
        // Set initial value
        if self.averageWalkSpeedRange.contains(averageSpeed) {
            self.averageWalkSpeed = averageSpeed
        }
        let duration = self.estimatedTime(distance: distance)
        let arriveTime = Date().addingTimeInterval(duration)
        
        self.isHidden = false
        self.restTimeLabel.text = self.format(duration: duration)
        
        let template = NSLocalizedString("Arrival Time $0", comment: "$0 = time")
        let arrivalTimeString = template.replacingOccurrences(of: "$0", with: self.format(date: arriveTime))
        self.arriveTimeLabel.text = arrivalTimeString
        
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
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: date)
    }
}
