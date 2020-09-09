//
//  RouteListViewController.swift
//  Mapping-Sample
//
//  Created on 8/9/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class RouteListViewController: UIViewController, SegmentedViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toolbar: ToolbarView!
    var route: PWRoute! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var sectionHeaderView: RouteInstructionHeaderView?
    var orientedCorrectly = false
    var selectedInstruction: PWRouteInstruction?
    
    let routeAccessibilityManager = RouteAccessibilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeAccessibilityManager.delegate = self
        
        let nib = UINib(nibName: String(describing: RouteInstructionHeaderView.self), bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: RouteInstructionHeaderView.self))
        tableView.estimatedRowHeight = 40.0
        tableView.estimatedSectionHeaderHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    func segmentedViewWillAppear() { }
    func segmentedViewWillDisappear() { }
    
    func cellFor(routeInstruction: PWRouteInstruction) -> RouteInstructionCell? {
        let indexPath = IndexPath(row: routeInstruction.indexOfInstruction(), section: 0)
        return tableView.cellForRow(at: indexPath) as? RouteInstructionCell
    }
}

// MARK: - UITableViewDelegate

extension RouteListViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension RouteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if route == nil {
            return 0
        }
        return route.routeInstructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteInstructionCell.self), for: indexPath)
        
        if let routeInstructionCell = cell as? RouteInstructionCell {
            let routeInstruction = route.routeInstructions[indexPath.row]
            routeInstructionCell.routeAccessibilityManager = routeAccessibilityManager
            routeInstructionCell.configureFor(routeInstruction: routeInstruction)
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RouteInstructionHeaderView.self))
        
        if let routeInstructionHeaderView = headerView as? RouteInstructionHeaderView {
            sectionHeaderView = routeInstructionHeaderView
            routeInstructionHeaderView.configureWith(route: route)
        }
        
        return headerView
    }
}

// MARK: - Accessibility

extension RouteListViewController {
    
    func voiceOverCurrentRouteInstruction() {
        guard let routeInstruction = route.routeInstructions.first else {
            return
        }
        if selectedInstruction == nil {
            selectedInstruction = routeInstruction
        }
        
        if let cell = cellFor(routeInstruction: routeInstruction) {
            if let accessibilityString = cell.accessibilityLabel {
                voiceOver(accessibilityString: accessibilityString, routeInstruction: routeInstruction)
            }
        }
    }
    
    func voiceOver(accessibilityString: String, routeInstruction: PWRouteInstruction) {
        selectedInstruction = routeInstruction
        
        if !orientedCorrectly {
            return
        }
        
        let lockQueue = DispatchQueue(label: "voiceOverQueue")
        lockQueue.sync {
            print(String(format: "VO(%@):::::::::::::%@", routeInstruction.indexOfInstruction(), accessibilityString))
            let indexPath = IndexPath(row: routeInstruction.indexOfInstruction(), section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            if let routeInstructionCell = tableView.cellForRow(at: indexPath) as? RouteInstructionCell {
                routeInstructionCell.accessibilityLabel = accessibilityString
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: routeInstructionCell)
            }
        }
    }
}

// MARK: - RouteAccessibilityManagerDelegate

extension RouteListViewController: RouteAccessibilityManagerDelegate {
    
    func routeInstruction(_ routeInstruction: PWRouteInstruction, didChangeOrientation accessibilityString: String, orientationIsCorrect: Bool) {
        guard let orientationLabel = sectionHeaderView?.orientationLabel else {
            return
        }
        if accessibilityString == orientationLabel.text {
            return
        }
        
        let needVoiceOver = !orientedCorrectly
        let needToStartRoute = !orientedCorrectly && orientationIsCorrect
        if orientationIsCorrect {
            orientationLabel.text = NSLocalizedString("You are oriented correctly.", comment: "")
            orientedCorrectly = true
        } else {
            orientationLabel.text = accessibilityString
        }
        
        if needVoiceOver {
            UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: orientationLabel)
        }
        
        if needToStartRoute {
            voiceOverCurrentRouteInstruction()
        }
    }
}
