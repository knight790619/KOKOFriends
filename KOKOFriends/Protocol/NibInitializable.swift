//
//  NibInitializable.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import UIKit

protocol NibInitializable: NibLoadable {}

extension NibInitializable where Self: UIView {
    static func instanciateFromNib() -> Self {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? Self else {
            fatalError("Could not instantiate view with nib name: \(nibName)")
        }
        return view
    }
}
