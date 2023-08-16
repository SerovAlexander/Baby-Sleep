//
//  TimerViewController.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 15.02.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {
    
    private let vieww = ChoiseTimerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(vieww)
        setupConstraint()
        
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0.5)

    }

    private func setupConstraint() {
        view.frame = CGRect(x: Int(self.view.bounds.width)/2, y: Int(self.view.bounds.height)/2, width: 300, height: 300)
        vieww.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(300)
        }
    }
}
