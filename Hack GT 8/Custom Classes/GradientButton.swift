//
//  GradientButton.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/23/21.
//

import UIKit

import UIKit
class GradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        let green = UIColor(red: 0.70, green: 0.94, blue: 0.62, alpha: 1.00)
        let cyan = UIColor(red: 0.56, green: 0.97, blue: 0.87, alpha: 1.00)
        l.colors = [green, cyan]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
