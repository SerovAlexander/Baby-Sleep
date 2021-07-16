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
protocol timerViewDelegate: AnyObject {
    func timerButtonTapped()
    func timeButtonTapped(timer: Int)
}


class ChoiseTimerView: UIView {
    
    private let conteinerView = UIView()
    private let fifteenView = TimerView(time: "15m", timer: 15)
    private let thirtyView = TimerView(time: "30m", timer: 30)
    private let fortyfiveView = TimerView(time: "45m", timer: 45)
    private let hourView = TimerView(time: "1h", timer: 60)
    private let twoHourView = TimerView(time: "2h", timer: 120)
    private let infinityView = TimerView(time: "∞", timer: 1)
    private let rightStackView = UIStackView()
    private let leftStackView = UIStackView()
    private let timerButton = UIButton()
    
    weak var delegate: timerViewDelegate?
    private var choseTime = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureConteinerView()
        configureRightStack()
        configureLeftStack()
        setupConstreint()
        configureTimerButton()
        setButtonTag()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(conteinerView)
        conteinerView.addSubview(rightStackView)
        conteinerView.addSubview(leftStackView)
        conteinerView.addSubview(timerButton)
        
        rightStackView.addArrangedSubview(thirtyView)
        rightStackView.addArrangedSubview(hourView)
        rightStackView.addArrangedSubview(infinityView)
        
        leftStackView.addArrangedSubview(fifteenView)
        leftStackView.addArrangedSubview(fortyfiveView)
        leftStackView.addArrangedSubview(twoHourView)
    }
    
    private func configureConteinerView() {
        conteinerView.backgroundColor = UIColor.background
        conteinerView.layer.cornerRadius = 25
        
        conteinerView.snp.makeConstraints {
            $0.bottom.top.leading.trailing.equalToSuperview()
        }
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
    
    private func configureTimerButton() {
        guard let timer = UIImage(named: "timer") else { return }
        
        timerButton.setImage(timer, for: .normal)
        timerButton.contentMode = .scaleAspectFit
        timerButton.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstreint() {
        rightStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.leading.equalTo(40)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.leading.equalTo(rightStackView.snp.trailing).offset(24)
        }
        
        timerButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.bottom.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setButtonTag() {
        fifteenView.tag = 1
        thirtyView.tag = 2
        fortyfiveView.tag = 3
        hourView.tag = 4
        twoHourView.tag = 5
        infinityView.tag = 6
        
        [fifteenView, thirtyView, fortyfiveView, hourView, twoHourView, infinityView].forEach {
            $0.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        }
    }
    
    
    @objc private func timerButtonTapped() {
        delegate?.timerButtonTapped()
    }
    
    @objc private func timeButtonTapped(sender: UIButton) {
        var time = 15
        switch sender.tag {
        case 1:
            time = 15
        case 2:
            time = 30
        case 3:
            time = 45
        case 4:
            time = 60
        case 5:
            time = 120
        case 6:
            time = 1
        default:
            time = 15
        }
        delegate?.timeButtonTapped(timer: time)
    }
}

