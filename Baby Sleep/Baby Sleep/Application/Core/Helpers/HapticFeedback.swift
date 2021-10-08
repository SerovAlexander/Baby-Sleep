//
//  HapticFeedback.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 01.12.2020.
//  Copyright © 2020 Aleksandr Serov. All rights reserved.
//

import UIKit

final class HapticFeedback {
    static func add() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}
