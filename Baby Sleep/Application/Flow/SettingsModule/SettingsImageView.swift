//
//  SettingsImageView.swift
//  Baby Sleep
//
//  Created by Серов Александр on 23.08.2023.
//  Copyright © 2023 Aleksandr Serov. All rights reserved.
//

import UIKit

class SettingsImageView: UIView {
    
    private var imageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(with image: UIImage, and color: UIColor) {
        self.backgroundColor = color
        self.imageView.image = image
    }
    
    
}

private extension SettingsImageView {
    func configure() {
        self.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.top.bottom.equalToSuperview().inset(5)
        }
    }
}
