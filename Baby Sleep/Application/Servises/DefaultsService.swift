//
//  DefaultsService.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 26.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import Foundation

enum DefaultsService {
//    static var helloShown: Bool {
//        set {
//            UserDefaults.standard.set(newValue, forKey: Router.helloShown)
//        }
//
//        get {
//            UserDefaults.standard.bool(forKey: Router.helloShown)
//        }
//    }
    
    static var isPremium: Bool = false {
        didSet {
            NotificationService.send(event: .premiumUpdated)
        }
    }
}

