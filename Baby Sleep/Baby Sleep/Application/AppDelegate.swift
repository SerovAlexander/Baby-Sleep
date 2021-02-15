// ----------------------------------------------------------------------------
//
//  AppDelegate.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 10.07.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import FirebaseCore
import FirebaseAuth
import UIKit

// ----------------------------------------------------------------------------

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // Anonimus Auth with Firebase
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user else { return }
            _ = user.isAnonymous  // true
            _ = user.uid
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
