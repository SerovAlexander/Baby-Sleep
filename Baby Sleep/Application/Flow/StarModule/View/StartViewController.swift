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

    // MARK: - UI

    let startButton = UIButton()

    // View for animation with Lottie
    let backgroundView = AnimationView()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureStartButton()
    }

    // MARK: - Configure UI

    private func configureStartButton() {
        startButton.backgroundColor = UIColor.buttonColor
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 32
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Black", size: 25.0)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        self.view.addSubview(startButton)

        // setup constrains
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(182)
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview().inset(50)
        }
    }

    private func configureBackgroundView() {
        self.view.addSubview(backgroundView)
        backgroundView.contentMode = .scaleAspectFill
        let animation = Animation.named("background")
        backgroundView.animation = animation
        backgroundView.play()
        backgroundView.loopMode = .loop

        //setup constraints
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Private Methods

    @objc private func startButtonAction() {
        let destinationVC = ControllerBuilder.createMainViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.show(destinationVC, sender: nil)
    
    }
}
