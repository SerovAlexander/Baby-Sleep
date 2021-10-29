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

class TimerView: UIButton {

    // MARK: - UI
    private let timeLabel = UILabel()
    private var timeString: String
    
    var time: Int
    
    // MARK: - Private Properties
    private let generator = UINotificationFeedbackGenerator()
    
    // MARK: - Init
    
    init(frame: CGRect, time: String, timer: Int) {
        self.timeString = time
        self.time = timer
        super.init(frame: frame)
        configure()
        setupConstreint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(time: String, timer: Int) {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.init(frame: frame, time: time, timer: timer)
    }
    
    private func configure() {
        timeLabel.textColor = .black
        timeLabel.text = timeString
        timeLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15.0)
        timeLabel.textAlignment = .center
        self.addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        self.addTarget(self, action: #selector(touchUp), for: [.touchCancel, .touchUpInside, .touchUpOutside, .touchDragExit])
    }
    
    private func setupConstreint() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
// MARK: - Handlers
extension TimerView {
    @objc func touchDown() {
        timeLabel.alpha = 0.6
        generator.notificationOccurred(.success)
    }
    
    @objc func touchUp() {
        timeLabel.alpha = 1
    }
}