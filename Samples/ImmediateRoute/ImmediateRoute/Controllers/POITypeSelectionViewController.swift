//
//  POITypeDatasource.swift
//  Mapping-Sample
//
//  Created on 7/19/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

typealias POISelectedCompletion = (_ poiType: PWPointOfInterestType?) -> Void

class POITypeSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var poiSelectedCompletion: POISelectedCompletion?
    
    var selectedPOIType: PWPointOfInterestType?
    var poiTypes = [PWPointOfInterestType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("POI Types", comment: "")
        
        navigationController?.navigationBar.barTintColor = CommonSettings.navigationBarBackgroundColor
        navigationController?.navigationBar.tintColor = CommonSettings.navigationBarForegroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : CommonSettings.viewForegroundColor]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close(barButtonItem:)))
    }
    
    func close(barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adjustedRowForIndex(indexPath: IndexPath) -> Int {
        return indexPath.row - 1
    }
}

extension POITypeSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiTypes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "POITypeSelectionCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("All Categories", comment: "")
            if selectedPOIType == nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let adjustedIndex = adjustedRowForIndex(indexPath: indexPath)
            let poiType = poiTypes[adjustedIndex]
            cell.textLabel?.text = poiType.name
            
            if let selectedPOIType = selectedPOIType, selectedPOIType == poiType {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell;
    }
}

extension POITypeSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let poiSelectedCompletion = poiSelectedCompletion {
            if indexPath.row == 0 {
                poiSelectedCompletion(nil)
            } else {
                let adjustedIndex = adjustedRowForIndex(indexPath: indexPath)
                let selectedPOIType = poiTypes[adjustedIndex]
                poiSelectedCompletion(selectedPOIType)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
