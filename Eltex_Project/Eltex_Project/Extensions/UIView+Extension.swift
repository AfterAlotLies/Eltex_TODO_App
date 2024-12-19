//
//  UIView+Extension.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit

extension UIView {
    func applyGradientBackground(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.bounds
        gradientLayer.name = "GradientLayer"
        
        self.layer.sublayers?.removeAll(where: { $0.name == "GradientLayer" })
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
