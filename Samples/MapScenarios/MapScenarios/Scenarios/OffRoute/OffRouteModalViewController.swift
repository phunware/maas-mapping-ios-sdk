//
//  OffRouteModalViewController.swift
//  MapScenarios
//
//  Created by 3/8/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import UIKit

class OffRouteModalViewController: UIViewController {

    @IBOutlet weak var offRouteDismissButton = UIButton()
    @IBOutlet weak var offRouteRerouteButton = UIButton()
    @IBOutlet weak var offRouteDontShowAgainButton = UIButton()

    var dismissCompletion : (() -> Void)?
    var rerouteCompletion : (() -> Void)?
    var dontShowAgainCompletion : (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    @IBAction func dismissButtonClicked(sender: UIButton) {
        dismissCompletion?()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func rerouteButtonClicked(sender: UIButton) {
        rerouteCompletion?()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dontShowAgainButtonClicked(sender: UIButton) {
        dontShowAgainCompletion?()
        self.dismiss(animated: true, completion: nil)
    }

}
