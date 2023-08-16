// ----------------------------------------------------------------------------
//
//  ViewController.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 10.07.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import Lottie
import SnapKit
import UIKit

// ----------------------------------------------------------------------------

class StartViewController: UIViewController {

    private let network = NetworkService()

    // View for animation with Lottie
    let backgroundView = AnimationView()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
    }

    // MARK: - Configure UI

    private func configureBackgroundView() {
        self.view.addSubview(backgroundView)
        backgroundView.contentMode = .scaleAspectFill
        let animation = Animation.named("background")
        backgroundView.animation = animation
        backgroundView.loopMode = .repeat(2)
        backgroundView.play { [weak self] _ in
            self?.startButtonAction()
        }

        //setup constraints
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Private Methods

    private func startButtonAction() {
        let destinationVC = ControllerBuilder.createMainViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.show(destinationVC, sender: nil)
    }
}
