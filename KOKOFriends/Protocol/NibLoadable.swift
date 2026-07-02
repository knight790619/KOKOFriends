//
//  NibLoadable.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import UIKit

protocol NibLoadable {}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
