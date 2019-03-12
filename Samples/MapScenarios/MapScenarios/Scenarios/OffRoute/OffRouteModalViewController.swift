//
//  OffRouteModalViewController.swift
//  MapScenarios
//
//  Created by Jason Fullen on 3/8/19.
//  Copyright © 2019 Patrick Dunshee. All rights reserved.
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
        if (dismissCompletion != nil) {
            dismissCompletion!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func rerouteButtonClicked(sender: UIButton) {
        if (rerouteCompletion != nil) {
            rerouteCompletion!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dontShowAgainButtonClicked(sender: UIButton) {
        if (dontShowAgainCompletion != nil) {
            dontShowAgainCompletion!()
        }
        self.dismiss(animated: true, completion: nil)
    }

}
