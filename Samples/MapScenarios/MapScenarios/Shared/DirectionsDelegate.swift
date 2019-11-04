//
//  DirectionsViewModelDelegate.swift
//  MapScenarios
//
//  Created by Aaron Pendley on 11/4/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

import Foundation
import PWMapKit

protocol DirectionsDelegate: class {
    func directions(for instruction: PWRouteInstruction) -> DirectionsViewModel
}
