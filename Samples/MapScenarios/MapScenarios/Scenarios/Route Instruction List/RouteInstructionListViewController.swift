//
//  RouteInstructionListViewController.swift
//  MapScenarios
//
//  Created on 2/27/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit

class RouteInstructionListViewController: UIViewController {
    
    let tableView = UITableView()
    var walkTimeView: WalkTimeView?
    
    var mapView: PWMapView? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route Instructions"
        
        configureTableView()
        
        NotificationCenter.default.addObserver(forName: .ExitWalkTimeButtonTapped, object: nil, queue: nil) { [weak self] (_) in
            self?.tableView.bottomAnchor.constraint(equalTo: self!.view.bottomAnchor).isActive = true
            self?.walkTimeView?.removeFromSuperview()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureTableView() {
        let displayedWalkTimeView = mapView?.subviews.first(where: { $0 is WalkTimeView }) as? WalkTimeView
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (displayedWalkTimeView != nil ? 80.0 : 0)).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        if let displayedWalkTimeView = displayedWalkTimeView, let walkTimeView = Bundle.main.loadNibNamed(String(describing: WalkTimeView.self), owner: nil, options: nil)?.first as? WalkTimeView {
            view.addSubview(walkTimeView)
            
            // Layout
            walkTimeView.translatesAutoresizingMaskIntoConstraints = false
            walkTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            walkTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            walkTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            walkTimeView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            walkTimeView.updateWalkTime(distance: displayedWalkTimeView.remainingDistance, averageSpeed: displayedWalkTimeView.averageSpeed)
            self.walkTimeView = walkTimeView
            
            NotificationCenter.default.addObserver(forName: .WalkTimeChanged, object: nil, queue: nil) { [weak self] (notification) in
                guard let remainingDistance = notification.userInfo?["distance"] as? CLLocationDistance, let averageSpeed = notification.userInfo?["speed"] as? CLLocationSpeed else {
                    return
                }
                
                self?.walkTimeView?.updateWalkTime(distance: remainingDistance, averageSpeed: averageSpeed)
            }
        }
        
        let instructionCellIdentifier = String(describing: RouteInstructionListCell.self)
        tableView.register(UINib(nibName: instructionCellIdentifier, bundle: nil), forCellReuseIdentifier: instructionCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
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

// MARK: - UITableViewDelegate

extension RouteInstructionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
}

// MARK: - UITableViewDataSource

extension RouteInstructionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapView?.currentRoute?.routeInstructions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let routeInstruction = mapView?.currentRoute?.routeInstructions[indexPath.row] else {
            return cell
        }
        if let instructionCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteInstructionListCell.self), for: indexPath) as? RouteInstructionListCell {
            instructionCell.configureWithRouteInstruction(routeInstruction)
            cell = instructionCell
        }
        return cell
    }
}
