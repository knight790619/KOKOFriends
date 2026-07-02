//
//  EmptyView.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import UIKit

class EmptyView: UIView {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var addFriendBackgroundView: UIView!
    @IBOutlet private weak var promptLabel: UILabel!
    @IBOutlet private weak var settingIDView: UIView! // 若用戶已設定 ID 則不顯示
    @IBOutlet private weak var settingIDLabel: UILabel!
    
    // MARK: - Private Property
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Life Cycle.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLayuot()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 圓角
        let radius = addFriendBackgroundView.bounds.height / 2
        gradientLayer.cornerRadius = radius
        
        // 漸層
        gradientLayer.frame = addFriendBackgroundView.bounds
    }
    
}

// MARK: - Configure

private extension EmptyView {
    
    func configureLayuot() {
        gradientLayer.colors = [
            UIColor(red: 86/255, green: 179/255, blue: 11/255, alpha: 1).cgColor,
            UIColor(red: 166/255, green: 204/255, blue: 66/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        addFriendBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        addFriendBackgroundView.layer.cornerRadius = addFriendBackgroundView.frame.height / 2
        
        let shadowColor = UIColor(red: 121/255, green: 196/255, blue: 27/255, alpha: 1)
        let shadowOffset = CGSize(width: 0, height: 4)
        
        addFriendBackgroundView.configureShadow(with: shadowColor, offset: shadowOffset, radius: 8, opacity: 0.4)
        
        let fullText = "幫助好友更快找到你？設定 KOKO ID"
        let highlightText = "設定 KOKO ID"
        
        let font = UIFont(name: "PingFangTC-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [.font: font, .foregroundColor: UIColor(resource: .lightGrey)])
        
        let range = (fullText as NSString).range(of: highlightText)
        attributedString.addAttributes([.foregroundColor: UIColor(resource: .hotPink), .underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
        
        settingIDLabel.attributedText = attributedString
    }
    
}

// MARK: - @IBAction

private extension EmptyView {
    
    @IBAction func didClickAddFriendButton(_ sender: Any) {
        
    }
    
    @IBAction func didClickSettingIDButton(_ sender: Any) {
        
    }
    
}

// MARK: - NibInitializable.

extension EmptyView: NibInitializable {}
