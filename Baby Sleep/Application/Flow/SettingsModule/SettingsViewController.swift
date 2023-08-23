//
//  SettingsViewController.swift
//  Baby Sleep
//
//  Created by Серов Александр on 23.08.2023.
//  Copyright © 2023 Aleksandr Serov. All rights reserved.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

}

private extension SettingsViewController {
    func configureViewController() {
        self.view.backgroundColor = .background
    }
}
