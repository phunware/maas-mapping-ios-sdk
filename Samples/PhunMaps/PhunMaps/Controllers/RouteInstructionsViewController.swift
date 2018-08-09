//
//  RouteInstructionsViewController.swift
//  Mapping-Sample
//
//  Created on 9/21/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

protocol RouteInstructionViewControllerDelegate {
    
    func didChangeRouteInstruction(route: PWRoute, routeInstruction: PWRouteInstruction)
}

extension Notification.Name {
    
    static let PWRouteInstructionChangedNotificationName = Notification.Name(PWRouteInstructionChangedNotificationKey)
}

class RouteInstructionsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var route: PWRoute? {
        didSet {
            updateForInstructionChange(currentIndex: 0)
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
        }
    }
    var delegate: RouteInstructionViewControllerDelegate?
    
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let collectionViewCellIdentifier = String(describing: RouteInstructionCollectionViewCell.self)
        collectionView.register(UINib(nibName: collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
        view.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeRouteInstruction(notification:)), name: Notification.Name.PWRouteInstructionChangedNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let offset = collectionView.contentOffset
        let width = collectionView.bounds.size.width
        
        let index = round(offset.x / width)
        
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        collectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(newOffset, animated: false)
        })
    }
    
    func updateForInstructionChange(currentIndex: Int) {
        guard let route = route, route.routeInstructions.count > currentIndex else {
            return
        }
        
        self.currentIndex = currentIndex
        let routeInstruction = route.routeInstructions[currentIndex]
        delegate?.didChangeRouteInstruction(route: route, routeInstruction: routeInstruction)
    }
    
    @objc func changeRouteInstruction(notification: Notification) {
        guard let routeInstruction = notification.object as? PWRouteInstruction, let route = route, route.routeInstructions[self.currentIndex] != routeInstruction else {
            return
        }
        
        if let index = route.routeInstructions.index(of: routeInstruction) {
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}

extension RouteInstructionsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = collectionView.contentOffset.x / collectionView.frame.size.width
        updateForInstructionChange(currentIndex: Int(currentIndex))
    }
}

extension RouteInstructionsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let route = route, let routeInstructions = route.routeInstructions else {
            return 0
        }
        return routeInstructions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let routeInstructionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RouteInstructionCollectionViewCell.self), for: indexPath) as? RouteInstructionCollectionViewCell {
            if let route = route, let routeInstructions = route.routeInstructions, routeInstructions.count > indexPath.row {
                routeInstructionCollectionViewCell.routeInstruction = routeInstructions[indexPath.row]
            }
            cell = routeInstructionCollectionViewCell
        }
        return cell
    }
}

extension RouteInstructionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
