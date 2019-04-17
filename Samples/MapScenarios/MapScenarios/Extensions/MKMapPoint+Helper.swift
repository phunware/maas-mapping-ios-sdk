//
//  MKMapPoint+Helper.swift
//  MapScenarios
//
//  Created on 2/15/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import MapKit

extension MKMapPoint {
    
    func distanceTo(_ polyline: MKPolyline) -> CLLocationDistance {
        var distance = CLLocationDistanceMax
        let linePoints = polyline.points()
        for i in 0...polyline.pointCount - 2 {
            let ptA = linePoints[i]
            let ptB = linePoints[i + 1]
            let xDelta = ptB.x - ptA.x
            let yDelta = ptB.y - ptA.y
            if xDelta == 0.0 && yDelta == 0.0 {
                continue
            }
            let u: CLLocationDistance = ((self.x - ptA.x) * xDelta + (self.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var closestPoint = MKMapPoint()
            if u < 0.0 {
                closestPoint = ptA
            } else if u > 1.0 {
                closestPoint = ptB
            } else {
                closestPoint = MKMapPoint(x: ptA.x + u * xDelta, y: ptA.y + u * yDelta)
            }
            distance = min(distance, closestPoint.distance(to: self))
        }
        return distance
    }
}
