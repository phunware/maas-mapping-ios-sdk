//
//  AppDelegate.swift
//  ImmediateRoute
//
//  Created on 4/24/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let applicationId = "<MaaS App ID>" /* Replace with the app id which comes from Phunware MaaS portal */
    let accessKey = "<MaaS Access Key>" /* Replace with the app access key which comes from Phunware MaaS portal */
    let signatureKey = "<Signature Key>"/* Replace with the app signature key which comes from Phunware MaaS portal */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        PWCore.setApplicationID(applicationId, accessKey: accessKey, signatureKey: signatureKey)
        
        return true
    }
}

