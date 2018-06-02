//
//  AppDelegate.swift
//  SiriKit2018
//
//  Created by Elizabeth Levosinski on 4/13/18.
//  Copyright © 2018 Elizabeth Levosinski. All rights reserved.
//

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        requestAuthorization()
        return true
    }
    
    func requestAuthorization() {
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                print("Siri services have been authorized")
            } else {
                print("Siri services have not been authorized")
            }
        }
    }
}
