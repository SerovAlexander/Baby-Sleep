//
//  BasicButton.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 23.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import UIKit

open class BasicButton: UIButton {
    
    open override var isHighlighted: Bool { didSet { isHighlighted == true ? touchDown() : touchUp() } }
    private lazy var indicatorView = UIActivityIndicatorView()
    public var isLoading = false {
        didSet {
            loading()
        }
    }
    
     // MARK: Lifecycle
    public init() {
        super.init(frame: .zero)
        adjustsImageWhenHighlighted = false
        setupButton()
        if #available(iOS 13.4, *) {
            isPointerInteractionEnabled = true
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        indicatorView.color = .white
        addSubview(indicatorView)
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public func loading() {
        if isLoading {
            isUserInteractionEnabled = false
            self.titleLabel?.alpha = 0
            self.imageView?.alpha = 0
            self.indicatorView.startAnimating()
        } else {
            isUserInteractionEnabled = true
            indicatorView.stopAnimating()
            self.titleLabel?.alpha = 1
            self.imageView?.alpha = 1
        }
    }
}

// MARK: - Handlers
extension BasicButton {
    @objc func touchDown() {
        titleLabel?.alpha = 0.6
        imageView?.alpha = 0.6
    }
    
    @objc func touchUp() {
        titleLabel?.alpha = 1
        imageView?.alpha = 1
    }
}
