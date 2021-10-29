//
//  PrivacyPolicyButton.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 23.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import UIKit

class PrivacyPolicyButton: UIButton {

    var color: UIColor { didSet { setupView() } }

    // MARK: Lifecycle
    override init(frame: CGRect) {
        color = .white
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Handlers
private extension PrivacyPolicyButton {
    @objc func buttonTapped() {
        guard let url = URL(string: "AS.Constants.privacyPolicyURL") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Layout Setup
private extension PrivacyPolicyButton {
    func setupView() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let mutableAttributedString = NSMutableAttributedString()
        let attribute = [
            NSAttributedString.Key.font: UIFont(name: "MontserratAlternates-Regular", size: 14),
            NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.052, blue: 0.486, alpha: 1)
        ]

        let privacyString = NSAttributedString(string: "Privacy Policy", attributes: attribute as [NSAttributedString.Key : Any])

        mutableAttributedString.append(privacyString)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        mutableAttributedString.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: mutableAttributedString.string.count))
        setAttributedTitle(mutableAttributedString, for: .normal)
    }
}
