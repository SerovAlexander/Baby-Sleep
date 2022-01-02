// ----------------------------------------------------------------------------

//  PriceView.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 23.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.

// ----------------------------------------------------------------------------

import SnapKit
import UIKit

class PriceView: UIButton {
    
    open override var isSelected: Bool { didSet { isSelected == true ? selectedState() : deselectedState() } }
    private(set) var subscriptionId: String = ""
    
    private lazy var priceLabel = UILabel()
    private lazy var periodLabel = UILabel()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureSubViews()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// ----------------------------------------------------------------------------

extension PriceView {
    public func setupPrice(_ price: String) {
        priceLabel.text = price
    }
    
    public func setupPeriod(_ period: String) {
        periodLabel.text = period
    }
    
    public func setupId(_ id: Subscriptions)  {
        subscriptionId = id.rawValue
    }
}

// ----------------------------------------------------------------------------

private extension PriceView {
    
    func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 20
    }
    
    func addViews() {
        addSubview(priceLabel)
        addSubview(periodLabel)
    }
    
    func configureSubViews() {
        setupPriceLabel()
        setupPeriodLabel()
    }
    
    func setupConstraints() {
        priceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(5).priority(.low)
        }
        
        self.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(160)
        }
    }
    
    func selectedState() {
        layer.borderColor = UIColor(red: 1, green: 0.052, blue: 0.486, alpha: 1).cgColor
        layer.borderWidth = 3

    }
    
    func deselectedState() {
        layer.borderColor = UIColor.hexColor("#D1D1E8").cgColor
        layer.borderWidth = 3
    }
    
    func setupPriceLabel() {
        priceLabel.textColor = .white
        priceLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 22)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.textAlignment = .center
    }
    
    func setupPeriodLabel() {
        periodLabel.textColor = .white
        periodLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 18)
    }
}

