//
//  CommonSubscriptionViewController.swift
//  Baby Sleep
//
//  Created by Серов Александр on 16.08.2023.
//  Copyright © 2023 Aleksandr Serov. All rights reserved.
//

import UIKit

class CommonSubscriptionViewController: UIViewController {

    var presenter: SubscriptionViewPresenterProtocol!
    private lazy var backGroundView = UIImageView()
    private lazy var closeButton = BasicButton()
    lazy var restoreButton = BasicButton()
    private lazy var mainTitleLabel = UILabel()
    private lazy var subTitleLabel = UILabel()
    lazy var continueButton = BasicButton()
    private lazy var privacyAndTermsStack = UIStackView()
    private lazy var termOfUseButton = TermsOfUseButton()
    private lazy var privacyPolicyButton = PrivacyPolicyButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        addViews()
        configureSubviews()
        setupConstraints()
    }
}

// ----------------------------------------------------------------------------

private extension CommonSubscriptionViewController {
    func configureController() {
        view.backgroundColor = .hexColor("#27255e")
        backGroundView.isUserInteractionEnabled = true
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
    }

    func configureSubviews() {
        setupBackgroundImageView()
        setupCloseButton()
        sutupMainTitleLabel()
        setupSubTitleLabel()
        setupPrivacyAndTermsStack()
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

    @objc func continueButtonTapped() {
        presenter.buyTapped()
    }
    
    @objc func restoreButtonTapped() {
        presenter.restoreTapped()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}