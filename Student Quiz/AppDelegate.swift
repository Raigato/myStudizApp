//
//  AppDelegate.swift
//  Student Quiz
//
//  Created by Gabriel Raymondou on 21/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        // StartApp config
        let sdk: STAStartAppSDK = STAStartAppSDK.sharedInstance()
        sdk.appID = "208494412"
        
        return true
    }

}

