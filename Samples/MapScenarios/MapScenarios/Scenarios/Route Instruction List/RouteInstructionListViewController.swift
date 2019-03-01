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
    
    var route: PWRoute? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Route Instructions"
        
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
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
}

// MARK: - UITableViewDataSource

extension RouteInstructionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route?.routeInstructions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let routeInstruction = route?.routeInstructions[indexPath.row] else {
            return cell
        }
        if let instructionCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouteInstructionListCell.self), for: indexPath) as? RouteInstructionListCell {
            instructionCell.configureWithRouteInstruction(routeInstruction)
            cell = instructionCell
        }
        return cell
    }
}
