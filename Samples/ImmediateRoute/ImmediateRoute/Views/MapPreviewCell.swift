//
//  MapPreviewCell.swift
//  Mapping-Sample
//
//  Created on 6/29/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import Foundation
import UIKit
import PWMapKit

class MapPreviewCell: UITableViewCell {
    
    var route: PWRoute!
    var routeAlreadyStarted = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureFor(mapView: PWMapView, route: PWRoute) {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        self.route = route
        routeAlreadyStarted = false
        
        if !mapView.isDescendant(of: self) {
            mapView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(mapView)
            mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            mapView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            mapView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
    }
}

// MARK: - PWMapViewDelegate

extension MapPreviewCell: PWMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if !routeAlreadyStarted {
            routeAlreadyStarted = true
            
            (mapView as? PWMapView)?.currentFloor = route.building.floor(byId: route.startPoint.floorID)
            (mapView as? PWMapView)?.navigate(with: route)
        }
    }
}
