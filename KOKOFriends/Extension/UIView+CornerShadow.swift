//
//  UIView+Shadow.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import UIKit

extension UIView {
    
    func configureShadow(with color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                         offset: CGSize = CGSize(width: 0, height: 4),
                         radius: CGFloat = 8,
                         opacity: Float = 0.1) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
}
