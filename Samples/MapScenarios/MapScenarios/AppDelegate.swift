//
//  AppDelegate.swift
//  MapScenarios
//
//  Created by Patrick Dunshee on 3/5/18.
//  Copyright © 2018 Patrick Dunshee. All rights reserved.
//

import UIKit
import PWCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
    let applicationId = ""
    let accessKey = ""
    let signatureKey = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        return true
    }
}

