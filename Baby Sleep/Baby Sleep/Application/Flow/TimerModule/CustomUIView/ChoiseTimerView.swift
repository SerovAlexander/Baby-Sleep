// ----------------------------------------------------------------------------
//
//  ChoiseTimerView.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 16.12.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import SnapKit
import UIKit

// ----------------------------------------------------------------------------

class ChoiseTimerView: UIView {
    
    private let fifteenView = TimerView(time: "15m")
    private let thirtyView = TimerView(time: "30m")
    private let fortyfiveView = TimerView(time: "45m")
    private let hourView = TimerView(time: "1h")
    private let twoHourView = TimerView(time: "2h")
    private let infinityView = TimerView(time: "∞")
    private let rightStackView = UIStackView()
    private let leftStackView = UIStackView()
    private let clearButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureRightStack()
        configureLeftStack()
        setupConstreint()
        configureClearButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = UIColor.background
        addSubview(rightStackView)
        addSubview(leftStackView)
        addSubview(clearButton)
    
        rightStackView.addArrangedSubview(thirtyView)
        rightStackView.addArrangedSubview(hourView)
        rightStackView.addArrangedSubview(infinityView)
        
        leftStackView.addArrangedSubview(fifteenView)
        leftStackView.addArrangedSubview(fortyfiveView)
        leftStackView.addArrangedSubview(twoHourView)
    }
    
    private func configureRightStack() {
        rightStackView.axis = .vertical
        rightStackView.alignment = .center
        rightStackView.spacing = 24
        rightStackView.distribution = .equalSpacing
        
        thirtyView.backgroundColor = .white
        hourView.backgroundColor = .white
        infinityView.backgroundColor = .white
        
        thirtyView.layer.cornerRadius = 15
        hourView.layer.cornerRadius = 15
        infinityView.layer.cornerRadius = 15
        
        thirtyView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        hourView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        infinityView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }
    
    private func configureLeftStack() {
        leftStackView.axis = .vertical
        leftStackView.alignment = .center
        leftStackView.spacing = 10
        leftStackView.distribution = .equalCentering
        
        fifteenView.backgroundColor = .white
        fortyfiveView.backgroundColor = .white
        twoHourView.backgroundColor = .white
        
        fifteenView.layer.cornerRadius = 15
        fortyfiveView.layer.cornerRadius = 15
        twoHourView.layer.cornerRadius = 15
        
        fifteenView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        fortyfiveView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        twoHourView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }

    }
    
    private func configureClearButton() {
        clearButton.setImage(UIImage(named: "xmark.circle.fill"), for: .normal)
        clearButton.backgroundColor = .red
        clearButton.addTarget(self, action: #selector(animat), for: .touchUpInside)
    }
    
    private func setupConstreint() {
        rightStackView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(24)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.left.equalTo(rightStackView.snp.right).offset(24)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.bottom.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc private func animat() {
        UIView.animate(withDuration: 1, animations: {
            self.rightStackView.isHidden = true
            self.leftStackView.isHidden = true
        }, completion: nil)
    }
}

