// ----------------------------------------------------------------------------
//
//  ControllerBuilder.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 01.12.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

//Builder class for initialisation controllers

protocol BuilderModulProtocol {
    static func createMainViewController () -> UIViewController
}

class ControllerBuilder: BuilderModulProtocol {
    static func createMainViewController() -> UIViewController {
        let mainViewController = MainViewController()
        let networkService = NetworkService()
        let audioService = AudioPlayer()
        let presenter = MainVCPresenter(view: mainViewController, networkService: networkService, audioPlayer: audioService)
        mainViewController.presenter = presenter
        
        return mainViewController
    }
    
    static func createSubscriptionController() -> UIViewController {
        let subscriptionController = SubscriptionViewController()
        let purchaseManager = PurchaseManager.shared
        let presenter = SubscriptionViewPresenter(view: subscriptionController, purchaseManager: purchaseManager)
        
        subscriptionController.presenter = presenter
        
        return subscriptionController
    }
}
