//
//  SubscriptionViewPresenter.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 27.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import Foundation

protocol SubscriptionViewPresenterProtocol {
    init(view: SubscriptionViewControllerProtocol, purchaseManager: PurchaseManager)
    var currentSubscriptionId: String? { get set }
    var yearPrice: String? { get set }
    var mounthPrice: String? { get set }
    var weekPrice: String? { get set }
    func getPrices()
    func buyTapped()
    func restoreTapped()
    func addObserver()
    
}

protocol SubscriptionViewControllerProtocol: AnyObject {
    func isPurchasing(_ isPurchasing: Bool)
    func isRestoring(_ isRestoring: Bool)
    func updatePrice()
    func purchaseSuccess()
    func purchaseError()
    func restoreSuccess()
    func restoreError()
    func userCancaled()
}

class SubscriptionViewPresenter: SubscriptionViewPresenterProtocol {
    
    var yearPrice: String?
    var mounthPrice: String?
    var weekPrice: String?
    weak var view: SubscriptionViewControllerProtocol?
    var currentSubscriptionId: String?
    private let purchaseManager: PurchaseManager
    
    required init (view: SubscriptionViewControllerProtocol, purchaseManager: PurchaseManager) {
        self.view = view
        self.purchaseManager = purchaseManager
        getPrices()
        addObserver()
    }
    
    func buyTapped() {
        view?.isPurchasing(true)
        guard let currentSubscriptionId = currentSubscriptionId else { return }
        purchaseManager.purchase(id: currentSubscriptionId) {
            self.view?.isPurchasing(false)
            self.view?.purchaseSuccess()
        } failed: { isCanceled in
            if isCanceled {
                self.view?.isPurchasing(false)
                self.view?.userCancaled()
            } else {
                self.view?.isPurchasing(false)
                self.view?.purchaseError()
            }
        }
    }
    
    func restoreTapped() {
        view?.isRestoring(true)
        purchaseManager.restore { [weak self] isSuccecc in
            guard let self = self else { return }
            if isSuccecc {
                self.view?.isRestoring(false)
                self.view?.restoreSuccess()
            } else {
                self.view?.isRestoring(false)
                self.view?.restoreError()
            }
        }
    }
    
    func getPrices() {
        yearPrice = purchaseManager.priceFor(productWithID: Subscriptions.oneYear.rawValue)
        mounthPrice = purchaseManager.priceFor(productWithID: Subscriptions.oneMonth.rawValue)
        weekPrice = purchaseManager.priceFor(productWithID: Subscriptions.oneWeek.rawValue)
//        view?.updatePrice()
    }
    
    func addObserver() {
        NotificationService.observe(event: .didFetchProducts) {
            self.getPrices()
        }
    }
}
