//
//  PreRoutingViewController.swift
//  Mapping-Sample
//
//  Created on 6/16/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

class PreRoutingViewController: UIViewController {
    
    enum rowMap: Int {
        case summary
        case routeLabel
        case showAllSteps
        case instruction
        case mapPreview
    }
    
    enum segment: String {
        case list = "List"
        case map = "Map"
        
        func localizedString() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startNavigationButton: UIButton!
    @IBOutlet weak var startNavigationButtonBottomConstraint: NSLayoutConstraint!
    
    var segmentedControl: UISegmentedControl!
    let segmentsList: [segment] = [.list, .map]
    var route: PWRoute?
    var showAllInstructions = !UIAccessibilityIsVoiceOverRunning()
    let mapViewForPreview = PWMapView()
    
    fileprivate var rowMapping = [rowMap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, startNavigationButton.frame.height+startNavigationButtonBottomConstraint.constant, 0.0)
        
        startNavigationButton.isHidden = route == nil
        startNavigationButton.layer.cornerRadius = 25
        startNavigationButton.clipsToBounds = true
        startNavigationButton.backgroundColor = CommonSettings.buttonBackgroundColor
        startNavigationButton.setTitle(NSLocalizedString("START NAVIGATION", comment: ""), for: .normal)
        startNavigationButton.addTarget(self, action: #selector(startNavigation(sender:)), for: .touchUpInside)
        
        if let route = route {
            mapViewForPreview.setBuilding(route.building)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureRowMapping(selectedSegment: .list)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSegmentedControl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        segmentedControl.isHidden = true
        navigationItem.titleView = nil
        super.viewWillDisappear(animated)
    }
    
    func configureRowMapping(selectedSegment: segment) {
        rowMapping = [rowMap]()
        rowMapping.append(.summary)
        
        switch selectedSegment {
        case .list:
            if showAllInstructions {
                rowMapping.append(.routeLabel)
                if let route = route {
                    for _ in 0..<route.routeInstructions.count {
                        rowMapping.append(.instruction)
                    }
                }
            } else {
                rowMapping.append(.showAllSteps)
            }
        case .map:
            rowMapping.append(.mapPreview)
        }
    }
}

// MARK: - Segmented Control

extension PreRoutingViewController {
    
    func configureSegmentedControl() {
        segmentedControl = UISegmentedControl()
        navigationItem.titleView = segmentedControl
        segmentedControl.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0..<segmentsList.count {
            segmentedControl.insertSegment(withTitle: segmentsList[index].localizedString(), at: index, animated: false)
            segmentedControl.setWidth(80.0, forSegmentAt: index)
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func segmentedControlChanged(_ sender: UISegmentedControl) {
        configureRowMapping(selectedSegment: segmentsList[segmentedControl.selectedSegmentIndex])
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension PreRoutingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = UITableViewAutomaticDimension
        if rowMapping[indexPath.row] == .mapPreview {
            height = 400.0
        }
        return height
    }
}

// MARK: - UITableViewDataSource

extension PreRoutingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowMapping.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch rowMapping[indexPath.row] {
        case .summary:
            if let routeSummaryCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteSummaryCell.self), for: indexPath) as? RouteSummaryCell {
                if let route = route {
                    routeSummaryCell.configureForRoute(route)
                }
                cell = routeSummaryCell
            }
        case .routeLabel:
            if let routeLabelCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteLabelCell.self), for: indexPath) as? RouteLabelCell {
                cell = routeLabelCell
            }
        case .showAllSteps:
            if let showAllInstructionsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowAllInstructionsCell.self), for: indexPath) as? ShowAllInstructionsCell {
                showAllInstructionsCell.configureForShowStepsSelector(#selector(showAllInstructions(sender:)), self)
                cell = showAllInstructionsCell
            }
        case .instruction:
            if let instructionCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PreRouteInstructionCell.self), for: indexPath) as? PreRouteInstructionCell {
                if let indexOffset = rowMapping.index(of: .instruction), let instruction = route?.routeInstructions[indexPath.row-indexOffset]as? PWRouteInstruction {
                    instructionCell.configure(forInstruction: instruction)
                }
                cell = instructionCell
            }
        case .mapPreview:
            if let mapPreviewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapPreviewCell.self), for: indexPath) as? MapPreviewCell {
                if let route = route {
                    mapPreviewCell.configureFor(mapView: mapViewForPreview, route: route)
                }
                cell = mapPreviewCell
            }
        }
        
        return cell
    }
}

// MARK: - Routing Actions

extension PreRoutingViewController {
    
    func showAllInstructions(sender: UIButton) {
        showAllInstructions = true
        configureRowMapping(selectedSegment: segmentsList[segmentedControl.selectedSegmentIndex])
        tableView.reloadData()
    }
    
    func startNavigation(sender: UIButton) {
        segmentedControl.isHidden = true
        navigationController?.popToRootViewController(animated: true)
        
        if let route = route {
            NotificationCenter.default.post(name: .startNavigatingRoute, object: route)
        }
    }
}
