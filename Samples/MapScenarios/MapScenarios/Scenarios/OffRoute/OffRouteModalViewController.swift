//
//  OffRouteModalViewController.swift
//  MapScenarios
//
//  Created by 3/8/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import UIKit

// MARK: - OffRouteModalViewController
protocol OffRouteModalViewControllerDelegate: class {
    func offRouteAlert(_ alert: OffRouteModalViewController, dismissedWithResult result: OffRouteModalViewController.Result)
}

// MARK: - OffRouteModalViewController
class OffRouteModalViewController: UIViewController {

    @IBOutlet weak var offRouteView: UIView!
    @IBOutlet weak var offRouteDismissButton: UIButton!
    @IBOutlet weak var offRouteRerouteButton: UIButton!
    @IBOutlet weak var offRouteDontShowAgainButton: UIButton!
    
    enum Result {
        case dismiss
        case reroute
        case dontShowAgain
    }
    
    weak var delegate: OffRouteModalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        self.offRouteView?.layer.cornerRadius = 5
        self.offRouteView?.layer.shadowColor = UIColor.black.cgColor
        self.offRouteView?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.offRouteView?.layer.shadowOpacity = 0.2
        self.offRouteView?.layer.shadowRadius = 1.0
    }

    @IBAction func dismissButtonClicked(sender: UIButton) {
        delegate?.offRouteAlert(self, dismissedWithResult: .dismiss)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rerouteButtonClicked(sender: UIButton) {
        delegate?.offRouteAlert(self, dismissedWithResult: .reroute)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dontShowAgainButtonClicked(sender: UIButton) {
        delegate?.offRouteAlert(self, dismissedWithResult: .dontShowAgain)
        dismiss(animated: true, completion: nil)
    }

}
