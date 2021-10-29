//
//  UIDeviceExtension.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 16.07.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8_SE2 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_11ProMax = "iPhone XS Max or iPhone 11 Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case iPhone_12mini = "iPhone_12_mini"
        case iPhone_12 = "iPhone 12"
        case iPhone_12_iPhone_12Pro = "iPhone_12_iPhone_12Pro"
        case iPhone_12ProMax = "iPhone 12 Pro Max"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8_SE2
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2340:
            return .iPhone_12mini
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2532:
            return .iPhone_12_iPhone_12Pro
        case 2688:
            return .iPhone_XSMax_11ProMax
        case 2778:
            return .iPhone_12ProMax
        default:
            return .unknown
        }
    }
    
    var isSmallScreen: Bool {
        return UIScreen.main.bounds.height < 600
    }
}
