//
//  NotificationService.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 27.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import Foundation

import Foundation
import ApphudSDK

public enum NotificationService {
    public enum Event {
        /// Статус пользователя изменился (есть или нет подписка)
        case premiumUpdated
        
        /// Это уведомление отправляется, когда SKProducts загружаются из StoreKit.
        case didFetchProducts
        
        var name: Notification.Name {
            switch self {
            case .premiumUpdated:
                return Notification.Name("premiumUpdated")
            case .didFetchProducts:
                return Apphud.didFetchProductsNotification()
            }
        }
    }
    
    public static func send(event: Event) {
        NotificationCenter.default.post(name: event.name, object: nil)
    }
    
    public static func observe(event: Event, clousure: @escaping() -> Void) {
        NotificationCenter.default.addObserver(
            forName: event.name,
            object: nil,
            queue: .main) { _ in
            clousure()
        }
    }
}
