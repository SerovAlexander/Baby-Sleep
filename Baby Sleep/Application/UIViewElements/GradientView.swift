//
//  GradientView.swift
//  Baby Sleep
//
//  Created by Aleksandr Serov on 23.10.2021.
//  Copyright © 2021 Aleksandr Serov. All rights reserved.
//

import UIKit

public class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    public var colors: [UIColor] = [.systemPink, .systemRed] {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var locations: [NSNumber] = [0, 1] {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var startPoint: CGPoint = .init(x: 0.25, y: 1) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var endPoint: CGPoint = .init(x: 0.75, y: 0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = colors.map { $0.cgColor }
        self.gradientLayer.startPoint = startPoint
        self.gradientLayer.endPoint = endPoint
        self.gradientLayer.locations = locations
    }
}
