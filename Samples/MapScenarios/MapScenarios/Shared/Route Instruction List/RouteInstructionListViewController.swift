//
//  RouteInstructionListViewController.swift
//  MapScenarios
//
//  Created on 2/27/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

// MARK: - RouteInstructionListViewControllerDelegate
protocol RouteInstructionListViewControllerDelegate: AnyObject {
    func routeInstructionListViewController(_ viewController: RouteInstructionListViewController, viewModelFor routeInstruction: PWRouteInstruction)
        -> InstructionViewModel
}

// MARK: - RouteInstructionListViewController
class RouteInstructionListViewController: UIViewController {
    enum WalkTimeDisplayMode {
        case hide
        case display(distance: CLLocationDistance, averageSpeed: CLLocationSpeed)
    }
    
    weak var delegate: RouteInstructionListViewControllerDelegate?
    weak var walkTimeViewDelegate: WalkTimeViewDelegate?
    
    private let tableView = UITableView()
    private var walkTimeView: WalkTimeView?
    
    private var route: PWRoute?
    
    // use this method to configure without a walk time view
    func configure(route: PWRoute?, walkTimeDisplayMode: WalkTimeDisplayMode = .hide) {
        self.route = route
        
        switch walkTimeDisplayMode {
        case .hide:
            break
        case .display(let distance, let averageSpeed):
            createWalkTimeView(distance: distance, averageSpeed: averageSpeed)
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route Instructions"
        
        configureTableView()
        layoutWalkTimeView()
    }
    
    func presentFromViewController(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: self)
        let closeButtonImage = #imageLiteral(resourceName: "CloseIcon").withRenderingMode(.alwaysTemplate)
        let closeButton = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action: #selector(dismissTapped))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        navigationController.navigationBar.barTintColor = .darkerGray
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.isTranslucent = false
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func updateWalkTime(distance: CLLocationDistance, averageSpeed: CLLocationSpeed) {
        walkTimeView?.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
    }
    
    @objc
    func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WalkTimeViewDelegate
extension RouteInstructionListViewController: WalkTimeViewDelegate {
    func exitButtonPressed(for walkTimeView: WalkTimeView) {
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.walkTimeView?.removeFromSuperview()
        self.walkTimeView = nil
        
        self.dismiss(animated: true, completion: nil)
        
        // forward to our own walkTimeViewDelegate
        self.walkTimeViewDelegate?.exitButtonPressed(for: walkTimeView)
    }
}

// MARK: - UITableViewDataSource
extension RouteInstructionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let route = route,
               let routeInstructions = route.routeInstructions else {
            return 0
        }
        
        // add 1 because we are going to add a "You have arrived" cell at the end
        return routeInstructions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: RouteInstructionListCell.self)
        
        // we are guaranteed a cell is returned from this method as long as the identifier is registered
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RouteInstructionListCell
        
        // if this is the index of a valid instruction
        if let routeInstructions = route?.routeInstructions, routeInstructions.indices.contains(indexPath.row) {
            let routeInstruction = routeInstructions[indexPath.row]
            
            // Get the view model from the delegate. If there is no delegate, use BasicInstructionViewModel.
            let viewModel = delegate?.routeInstructionListViewController(self, viewModelFor: routeInstruction)
                ?? BasicInstructionViewModel(for: routeInstruction)
            
            cell.configure(with: viewModel)
        } else {
            // otherwise this is the "You have arrived" cell
            let destinationName = route?.endPoint.title ?? nil
            let viewModel = ArrivedInstructionViewModel(destinationName: destinationName)
            cell.configure(with: viewModel)
        }
        
        return cell
    }
}

// MARK: - private
private extension RouteInstructionListViewController {
    func createWalkTimeView(distance: CLLocationDistance, averageSpeed: CLLocationSpeed) {
        let bundleName = String(describing: WalkTimeView.self)
        let walkTimeView = Bundle.main.loadNibNamed(bundleName, owner: nil, options: nil)!.first as! WalkTimeView
        self.walkTimeView = walkTimeView
        walkTimeView.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
    }
    
    func layoutWalkTimeView() {
        guard let walkTimeView = self.walkTimeView else {
            return
        }
        
        view.addSubview(walkTimeView)
        
        walkTimeView.translatesAutoresizingMaskIntoConstraints = false
        walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        walkTimeView.heightAnchor.constraint(equalToConstant: WalkTimeView.defaultHeight).isActive = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
            
        let bottomAnchorConstant = (walkTimeView == nil)
            ? 0
            : -WalkTimeView.defaultHeight
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchorConstant).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let instructionCellIdentifier = String(describing: RouteInstructionListCell.self)
        tableView.register(UINib(nibName: instructionCellIdentifier, bundle: nil), forCellReuseIdentifier: instructionCellIdentifier)
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        // putting an invisible view as the footer view will hide the empty table view rows after the last valid one
        tableView.tableFooterView = UIView(frame: .zero)
    }
}
