//
//  ViewController.swift
//  MapScenarios
//
//  Created by Patrick Dunshee on 3/5/18.
//  Copyright © 2018 Patrick Dunshee. All rights reserved.
//

import UIKit

class ScenarioSelectViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

