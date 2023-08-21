//
//  LifeTimeSubscriptionsViewController.swift
//  Baby Sleep
//
//  Created by Серов Александр on 16.08.2023.
//  Copyright © 2023 Aleksandr Serov. All rights reserved.
//

import UIKit
import SPAlert

class LifeTimeSubscriptionsViewController: CommonSubscriptionViewController {
    
    private lazy var lifeTimePriceView = PriceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
        self.configureSubviews()
        self.setupConstraints()
    }

}

extension LifeTimeSubscriptionsViewController: SubscriptionViewControllerProtocol {
    
    func isPurchasing(_ isPurchasing: Bool) {
        print("isPurchasing")
        continueButton.isLoading = true
        restoreButton.isEnabled = false
        lifeTimePriceView.isUserInteractionEnabled = false
    }

    func isRestoring(_ isRestoring: Bool) {
        restoreButton.isLoading = true
        continueButton.isEnabled = false
        lifeTimePriceView.isUserInteractionEnabled = false
    }

    func updatePrice() {
        lifeTimePriceView.setupPrice(presenter.yearPrice ?? "")
    }

    func purchaseSuccess() {
        SPAlert.present(title: "Success", preset: .done, haptic: .success) {
            self.dismiss(animated: true)
        }
    }

    func purchaseError() {
        print("purchaseError")
        continueButton.isLoading = false
        restoreButton.isEnabled = true
        lifeTimePriceView.isUserInteractionEnabled = true
    }

    func restoreSuccess() {
        print("restoreSuccess")
    }

    func restoreError() {
        print("restoreError")
        restoreButton.isLoading = false
        continueButton.isEnabled = true
        lifeTimePriceView.isUserInteractionEnabled = true
    }

    func userCancaled() {
        print("userCancaled")
    }
    
}

private extension LifeTimeSubscriptionsViewController {
    
    func addSubviews() {
        self.view.addSubview(self.lifeTimePriceView)
        self.presenter.currentSubscriptionId = Subscriptions.oneWeek.rawValue
    }
    
    func configureSubviews() {
        lifeTimePriceView.do {
            $0.setupId(.lifeTime)
            $0.setupPeriod("Lifetime")
            $0.isSelected = true
        }
    }
    
    func setupConstraints() {
        lifeTimePriceView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.continueButton.snp.top).offset(-40)
        }
    }
    
}
