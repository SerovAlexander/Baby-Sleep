// ----------------------------------------------------------------------------
//
//  TimerView.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 16.12.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//
// ----------------------------------------------------------------------------

import SnapKit
import UIKit

// ----------------------------------------------------------------------------

class TimerView: UIView {

    // MARK: - UI
    private let timeLabel = UILabel()
    
    private var time: String
    
    // MARK: - Init
    
     init(frame: CGRect, time: String) {
        self.time = time
        super.init(frame: frame)
        configure()
        setupConstreint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(time: String) {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.init(frame: frame, time: time)
    }
    
    private func configure() {
        timeLabel.textColor = .black
        timeLabel.text = time
        timeLabel.font = .systemFont(ofSize: 15)
        timeLabel.textAlignment = .center
    }
    
    private func setupConstreint() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
//            make.height.equalTo(18)
//            make.width.equalTo(30)
            make.center.equalToSuperview()
        }
    }
}
