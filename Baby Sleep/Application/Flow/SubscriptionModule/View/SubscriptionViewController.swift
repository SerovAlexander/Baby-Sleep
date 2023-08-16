// ----------------------------------------------------------------------------
//  SubscriptionViewController.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 23.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
// ----------------------------------------------------------------------------

import SnapKit
import UIKit

// ----------------------------------------------------------------------------

class SubscriptionViewController: UIViewController {

    var presenter: SubscriptionViewPresenterProtocol!
    private lazy var backGroundView = UIImageView()
    private lazy var closeButton = BasicButton()
    private lazy var restoreButton = BasicButton()
    private lazy var mainTitleLabel = UILabel()
    private lazy var subTitleLabel = UILabel()
    private lazy var continueButton = BasicButton()
    private lazy var privacyAndTermsStack = UIStackView()
    private lazy var termOfUseButton = TermsOfUseButton()
    private lazy var privacyPolicyButton = PrivacyPolicyButton()
    private lazy var weekPriceView = PriceView()
    private lazy var mounthPriceView = PriceView()
    private lazy var yearPriceView = PriceView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        addViews()
        configureSubviews()
        setupConstraints()
        yearPriceView.isSelected = true
        weekPriceView.isSelected = false
        mounthPriceView.isSelected = false
        backGroundView.isUserInteractionEnabled = true
        getPrices()
        addObserver()
    }
}

// ----------------------------------------------------------------------------

private extension SubscriptionViewController {
    func configureController() {
        view.backgroundColor = UIColor(red: 39.0 / 255.0, green: 37.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }

    func addViews() {
        view.addSubview(backGroundView)
        backGroundView.addSubview(closeButton)
        backGroundView.addSubview(restoreButton)
        backGroundView.addSubview(mainTitleLabel)
        backGroundView.addSubview(subTitleLabel)
        backGroundView.addSubview(continueButton)
        privacyAndTermsStack.addArrangedSubview(termOfUseButton)
        privacyAndTermsStack.addArrangedSubview(privacyPolicyButton)
        backGroundView.addSubview(privacyAndTermsStack)
        backGroundView.addSubview(weekPriceView)
        backGroundView.addSubview(mounthPriceView)
        backGroundView.addSubview(yearPriceView)
    }

    func configureSubviews() {
        setupBackgroundImageView()
        setupCloseButton()
        sutupMainTitleLabel()
        setupSubTitleLabel()
        setupPrivacyAndTermsStack()
        setupPriceButtons()
        setupRestoreButton()
        setupContinueButton()
    }

    func setupConstraints() {

        backGroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(30)
        }

        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }

        continueButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }

        privacyAndTermsStack.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.width.equalTo(210)
            $0.centerX.equalToSuperview()
        }

        restoreButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(privacyAndTermsStack.snp.top).offset(-5)
        }

        yearPriceView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).offset(-40)
        }

        weekPriceView.snp.makeConstraints {
            $0.centerY.equalTo(yearPriceView)
            $0.trailing.equalTo(yearPriceView.snp.leading).offset(-2)
            weekPriceView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }

        mounthPriceView.snp.makeConstraints {
            $0.centerY.equalTo(yearPriceView)
            $0.leading.equalTo(yearPriceView.snp.trailing).offset(2)
            mounthPriceView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }

    func setupBackgroundImageView() {
        backGroundView.image = UIImage(named: "subBack")
        backGroundView.contentMode = .scaleAspectFill
    }

    func setupCloseButton() {
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
    }

    func setupRestoreButton() {
        restoreButton.setTitle("Restore Purchases", for: .normal)
        restoreButton.setTitleColor(.white, for: .normal)
        restoreButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Regular", size: 13.0)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }

    func sutupMainTitleLabel() {
        mainTitleLabel.text = "Экономьте \n больше, \n спите лучше!"
        mainTitleLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 32)
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.numberOfLines = 3
        mainTitleLabel.textColor = .white
    }

    func setupSubTitleLabel() {
        subTitleLabel.text = "Экономьте больше, \n спите лучше!"
        subTitleLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 18.0)
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 2
        subTitleLabel.textColor = .white
    }

    func setupContinueButton() {
        continueButton.setTitle("Continue", for: .normal)
        continueButton.layer.cornerRadius = 30
        continueButton.titleLabel?.textColor = .white
        continueButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Bold", size: 19)
        continueButton.backgroundColor = UIColor(red: 1, green: 0.052, blue: 0.486, alpha: 1)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }

    func setupPrivacyAndTermsStack() {
        privacyAndTermsStack.axis = .horizontal
        privacyAndTermsStack.spacing = 2
        privacyAndTermsStack.distribution = .fillEqually
    }

    func setupPriceButtons() {
        yearPriceView.setupId(.oneYear)
        mounthPriceView.setupId(.oneMonth)
        weekPriceView.setupId(.oneWeek)
        yearPriceView.setupPeriod("Year")
        weekPriceView.setupPeriod("Week")
        mounthPriceView.setupPeriod("Month")
        yearPriceView.addTarget(self, action: #selector(priceButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        weekPriceView.addTarget(self, action: #selector(priceButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        mounthPriceView.addTarget(self, action: #selector(priceButtonTapped(_:)), for: UIControl.Event.touchUpInside)
    }

    @objc func priceButtonTapped(_ sender: UIButton) {
        let subscrebeViews = [weekPriceView, mounthPriceView, yearPriceView]
        guard let subscribeView = sender as? PriceView else { return }
        guard !subscribeView.isSelected else { return }
        subscrebeViews.forEach {
            $0.isSelected = false
            $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        UISelectionFeedbackGenerator().selectionChanged()
        subscribeView.isSelected = true
        subscribeView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        presenter.currentSubscriptionId = subscribeView.subscriptionId
        print(presenter.currentSubscriptionId)
    }

    @objc func continueButtonTapped() {
        presenter.buyTapped()
    }
    
    @objc func restoreButtonTapped() {
        presenter.restoreTapped()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addObserver() {
        NotificationService.observe(event: .didFetchProducts) { [weak self] in
            guard let self = self else { return }
            self.getPrices()
        }
    }
    
    func getPrices() {
        yearPriceView.setupPrice(PurchaseManager.shared.priceFor(productWithID: Subscriptions.oneYear.rawValue))
        weekPriceView.setupPrice(PurchaseManager.shared.priceFor(productWithID: Subscriptions.oneMonth.rawValue))
        mounthPriceView.setupPrice(PurchaseManager.shared.priceFor(productWithID: Subscriptions.oneWeek.rawValue))
    }
}

extension SubscriptionViewController: SubscriptionViewControllerProtocol {
    func isPurchasing(_ isPurchasing: Bool) {
        print("isPurchasing")
        continueButton.isLoading = true
        restoreButton.isEnabled = false
        weekPriceView.isUserInteractionEnabled = false
        mounthPriceView.isUserInteractionEnabled = false
        yearPriceView.isUserInteractionEnabled = false
    }

    func isRestoring(_ isRestoring: Bool) {
        restoreButton.isLoading = true
        continueButton.isEnabled = false
        weekPriceView.isUserInteractionEnabled = false
        mounthPriceView.isUserInteractionEnabled = false
        yearPriceView.isUserInteractionEnabled = false
    }

    func updatePrice() {
        yearPriceView.setupPrice(presenter.yearPrice ?? "")
        weekPriceView.setupPrice(presenter.weekPrice ?? "")
        mounthPriceView.setupPrice(presenter.mounthPrice ?? "" )
    }

    func purchaseSuccess() {
        print("purchaseSuccess")
    }

    func purchaseError() {
        print("purchaseError")
        continueButton.isLoading = false
        restoreButton.isEnabled = true
        weekPriceView.isUserInteractionEnabled = true
        mounthPriceView.isUserInteractionEnabled = true
        yearPriceView.isUserInteractionEnabled = true
    }

    func restoreSuccess() {
        print("restoreSuccess")
    }

    func restoreError() {
        print("restoreError")
        restoreButton.isLoading = false
        continueButton.isEnabled = true
        weekPriceView.isUserInteractionEnabled = true
        mounthPriceView.isUserInteractionEnabled = true
        yearPriceView.isUserInteractionEnabled = true
    }

    func userCancaled() {
        print("userCancaled")
    }
}
