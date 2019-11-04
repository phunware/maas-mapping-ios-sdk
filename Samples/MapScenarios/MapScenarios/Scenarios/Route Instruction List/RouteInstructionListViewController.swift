//
//  RouteInstructionListViewController.swift
//  MapScenarios
//
//  Created on 2/27/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

class RouteInstructionListViewController: UIViewController {
    enum WalkTimeDisplayMode {
        case none
        case displayed(distance: CLLocationDistance, averageSpeed: CLLocationSpeed)
        
        var isDisplayed: Bool {
            if case .displayed = self {
                return true
            }
            
            return false
        }
    }
    
    private let tableView = UITableView()
    private var walkTimeView: WalkTimeView?
    
    private var route: PWRoute?
    private var enableLandmarkRouting: Bool = false
    private var walkTimeDisplayMode: WalkTimeDisplayMode = .none
    
    func configure(route: PWRoute?, enableLandmarkRouting: Bool = false, walkTimeDisplayMode: WalkTimeDisplayMode = .none) {
        self.route = route
        self.walkTimeDisplayMode = walkTimeDisplayMode
        self.enableLandmarkRouting = enableLandmarkRouting
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route Instructions"
        
        configureTableView()
        configureWalkTimeView()
        
        // Dismiss when the exit button is pressed.
        NotificationCenter.default.addObserver(forName: .ExitWalkTimeButtonTapped, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.walkTimeView?.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureWalkTimeView() {
        guard case .displayed(let distance, let averageSpeed) = walkTimeDisplayMode else {
            return
        }
        
        let bundleName = String(describing: WalkTimeView.self)
        let walkTimeView = Bundle.main.loadNibNamed(bundleName, owner: nil, options: nil)!.first as! WalkTimeView
        
        view.addSubview(walkTimeView)
        
        walkTimeView.translatesAutoresizingMaskIntoConstraints = false
        walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        walkTimeView.heightAnchor.constraint(equalToConstant: WalkTimeView.defaultHeight).isActive = true
        walkTimeView.updateWalkTime(distance: distance, averageSpeed: averageSpeed)
        self.walkTimeView = walkTimeView
        
        NotificationCenter.default.addObserver(forName: .WalkTimeChanged, object: nil, queue: nil) { [weak self] (notification) in
            guard let walkTimeView = self?.walkTimeView else {
                return
            }
            
            guard let remainingDistance = notification.userInfo?[NotificationUserInfoKeys.remainingDistance] as? CLLocationDistance,
                let averageSpeed = notification.userInfo?[NotificationUserInfoKeys.averageSpeed] as? CLLocationSpeed else {
                return
            }
            
            walkTimeView.updateWalkTime(distance: remainingDistance, averageSpeed: averageSpeed)
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
            
        let bottomAnchorConstant = walkTimeDisplayMode.isDisplayed
            ? -WalkTimeView.defaultHeight
            : 0
        
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
    
    @objc
    func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension RouteInstructionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let instructionCount = route?.routeInstructions.count ?? 0
        
        // add 1 because we are going to add a "You have arrived" cell at the end
        return instructionCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: RouteInstructionListCell.self)
        
        // we are guaranteed a cell is returned from this method as long as the identifier is registered
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RouteInstructionListCell
        
        // if this is the index of a valid instruction
        
        if let routeInstructions = route?.routeInstructions, routeInstructions.indices.contains(indexPath.row) {
            let routeInstruction = routeInstructions[indexPath.row]
            
            // If landmark routing is enabled, use the LandmarkDirectionsViewModel to provide instruction text using landmarks.
            // Otherwise, use the StandardDirectionsViewModel to provide default instruction text.
            let viewModel: DirectionsViewModel = enableLandmarkRouting
                ? LandmarkDirectionsViewModel(for: routeInstruction)
                : StandardDirectionsViewModel(for: routeInstruction)
            
            cell.configure(with: viewModel)
        } else {
            // otherwise this is the "You have arrived" cell
            let destinationName = route?.endPoint.title ?? nil
            let viewModel = ArrivedDirectionsViewModel(destinationName: destinationName)
            cell.configure(with: viewModel)
        }
        
        return cell
    }
}
