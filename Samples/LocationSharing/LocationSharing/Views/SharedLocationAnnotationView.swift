//
//  DotAnnotationView.swift
//  LocationSharing
//
//  Created on 5/25/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import SVPulsingAnnotationView

extension Notification.Name {
    static let didUpdateAnnotation = Notification.Name("didUpdateAnnotation")
}

class SharedLocationAnnotationView: MKAnnotationView {

    let floatingTextLabel = UILabel()
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, color: UIColor) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateAnnotation), name: .didUpdateAnnotation, object: nil)
        
        configureFloatingTextLabel()
        
        image = circleImageWithColor(color: color, height: 15.0)
    }
    
    func circleImageWithColor(color: UIColor, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: height, height: height), false, 0)
        let fillPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: height, height: height))
        color.setFill()
        fillPath.fill()
        
        let dotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return dotImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Floating Text Label

extension SharedLocationAnnotationView {
    
    func configureFloatingTextLabel() {
        addSubview(floatingTextLabel)
        floatingTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addFloatingText(_ text: String) {
        floatingTextLabel.text = text
        floatingTextLabel.sizeToFit()

        floatingTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        floatingTextLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
    }
    
    func didUpdateAnnotation() {
        DispatchQueue.main.async { [weak self] in
            guard let annotation = self?.annotation as? SharedLocationAnnotation else {
                return
            }
            
            self?.addFloatingText("\(annotation.sharedLocation.displayName!) (\(annotation.sharedLocation.userType!))")
        }
    }
}
