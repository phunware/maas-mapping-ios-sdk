//
//  TurnByTurnCollectionView.swift
//  MapScenarios
//
//  Created on 2/22/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import PWMapKit
import UIKit

protocol TurnByTurnDelegate: class {
    
    func didSwipeOnRouteInstruction()
    func instructionExpandTapped()
}

class TurnByTurnCollectionView: UICollectionView {
    
    let mapView: PWMapView
    
    weak var turnByTurnDelegate: TurnByTurnDelegate?
    
    fileprivate let itemPercentOfScreenWidth: CGFloat = 0.85
    fileprivate var interItemPadding: CGFloat {
        return sidePadding / 2.0
    }
    fileprivate var sidePadding: CGFloat {
        return calculateSidePaddingFromFrame(frame)
    }
    fileprivate var itemSize: CGSize {
        return calculateItemSizeFromFrame(frame)
    }
    fileprivate var itemCount: Int {
        guard let route = mapView.currentRoute, let routeInstructions = route.routeInstructions else {
            return 0
        }
        return routeInstructions.count
    }
    fileprivate var currentIndex: Int {
        let floatIndex = (contentOffset.x + sidePadding) / (itemSize.width + interItemPadding)
        let calculatedIndex = Int(round(floatIndex))
        return max(0, min(itemCount - 1, calculatedIndex))
    }
    fileprivate var indexOfCellBeforeDragging = 0
    
    init(mapView: PWMapView) {
        self.mapView = mapView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        showsHorizontalScrollIndicator = false
        isPagingEnabled = false
        bounces = true
        backgroundColor = .white
        delegate = self
        dataSource = self
        backgroundColor = .clear
        clipsToBounds = false
        decelerationRate = UIScrollView.DecelerationRate.fast
        
        let collectionViewCellIdentifier = String(describing: TurnByTurnInstructionCollectionViewCell.self)
        register(UINib(nibName: collectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        mapView = PWMapView()
        super.init(coder: aDecoder)
    }
    
    func configureInView(_ view: UIView) {
        if superview == nil {
            view.addSubview(self)
            
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        }
        
        let sidePadding = calculateSidePaddingFromFrame(view.frame)
        contentInset = UIEdgeInsets(top: 0.0, left: sidePadding, bottom: 0.0, right: sidePadding)
        
        reloadData()
        contentOffset = CGPoint(x: -sidePadding, y: 0)
    }
    
    fileprivate func calculateSidePaddingFromFrame(_ frame: CGRect) -> CGFloat {
        return (frame.width - (calculateItemSizeFromFrame(frame).width)) / 2.0
    }
    
    fileprivate func calculateItemSizeFromFrame(_ frame: CGRect) -> CGSize {
        return CGSize(width: frame.width * itemPercentOfScreenWidth, height: frame.height)
    }
    
    func scrollToInstruction(_ routeInstruction: PWRouteInstruction) {
        guard let indexOfInstruction = mapView.currentRoute.routeInstructions.firstIndex(of: routeInstruction) else {
            return
        }
        
        if indexOfInstruction != currentIndex {
            scrollToIndex(indexOfInstruction)
        }
    }
    
    fileprivate func scrollToIndex(_ index: Int, currentSwipeVelocity: CGFloat = 0.0, targetContentOffset: UnsafeMutablePointer<CGPoint>? = nil) {
        let targetOffset = ((itemSize.width + interItemPadding) * CGFloat(index)) - sidePadding
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: currentSwipeVelocity, options: [], animations: { [weak self] in
            if let targetContentOffset = targetContentOffset {
                targetContentOffset.pointee = CGPoint(x: targetOffset, y: 0)
            } else {
                self?.contentOffset = CGPoint(x: targetOffset, y: 0)
                self?.superview?.layoutIfNeeded()
            }
        }, completion: nil)
    }
}

// MARK - UICollectionViewDataSource

extension TurnByTurnCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let routeInstructionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TurnByTurnInstructionCollectionViewCell.self), for: indexPath) as? TurnByTurnInstructionCollectionViewCell {
            if let route = mapView.currentRoute, let routeInstructions = route.routeInstructions, routeInstructions.count > indexPath.row {
                routeInstructionCollectionViewCell.updateForRouteInstruction(routeInstructions[indexPath.row])
            }
            routeInstructionCollectionViewCell.buttonAction = { [weak self] in
                self?.turnByTurnDelegate?.instructionExpandTapped()
            }
            cell = routeInstructionCollectionViewCell
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TurnByTurnCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemPadding
    }
}

// MARK: - UIScrollViewDelegate

extension TurnByTurnCollectionView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = currentIndex
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset

        let swipeVelocityThreshold: CGFloat = 0.5

        let currentCellIsTheCellBeforeDragging = currentIndex == indexOfCellBeforeDragging
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < itemCount && velocity.x > swipeVelocityThreshold
        let notInFirstCellBeforeDragging = (indexOfCellBeforeDragging - 1) >= 0
        let hasEnoughVelocityToSlideToThePreviousCell = notInFirstCellBeforeDragging && velocity.x < -swipeVelocityThreshold
        let didUseSwipeToSkipCell = currentCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            turnByTurnDelegate?.didSwipeOnRouteInstruction()
            scrollToIndex(snapToIndex, targetContentOffset: targetContentOffset)
        } else {
            scrollToIndex(currentIndex, targetContentOffset: targetContentOffset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let newInstruction = mapView.currentRoute.routeInstructions?[currentIndex] else {
            return
        }
        
        mapView.setRouteManeuver(newInstruction)
    }
}
