//
//  MainTabbarController.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/29.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var customTabbar: UITabBar!
    
    // MARK: - Private Property
    
    private let customButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        
        selectedIndex = 1 // 進入時直接選擇到朋友 tab
    }
    
    override func viewDidLayoutSubviews() {
        configureCustomButton()
    }
    
}

// MARK: - Configure

private extension MainTabbarController {
    
    func configureLayout() {
        customTabbar.unselectedItemTintColor = .warmGrey
        customTabbar.tintColor = .hotPink
    }
    
    // 自訂異形 tabbarItem
    func configureCustomButton() {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.background.backgroundColor = .clear
        config.contentInsets = .zero
        config.background.image = UIImage(resource: .icTabbarHomeOff)
        customButton.configuration = config
        
        customButton.configurationUpdateHandler = { button in
            var updated = button.configuration
            updated?.showsActivityIndicator = false
            updated?.baseForegroundColor = .label
            updated?.background.backgroundColor = .clear
            updated?.background.strokeColor = .clear
            updated?.background.strokeWidth = 0
            button.configuration = updated
        }
        
        customButton.addTarget(self, action: #selector(showViewController), for: .touchDown)
        
        let buttonWidth = customTabbar.frame.width * 0.227 // 示意圖比例元件與螢幕寬度比為 22.7%
        let buttonHeight = buttonWidth * 0.8 // 示意圖寬高比為 85:68 (68/85 = 0.8)
        
        // 設定 customButton
        customButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        
        // 取得 TabBar 總高度 (包含安全區域)
        let tabbarItemHeight = customTabbar.frame.height - customTabbar.safeAreaInsets.bottom // 取得實際 tabbarItem 高度
        customButton.center.x = customTabbar.frame.width / 2
        customButton.center.y = tabbarItemHeight - (buttonHeight / 2)
        customTabbar.addSubview(customButton)
        
        // 設定 tabbarBackground
        let tabbarBgImageView = UIImageView()
        let tabbarImage = UIImage(resource: .imgTabbarBg)
        tabbarBgImageView.image = tabbarImage
        tabbarBgImageView.frame.size = CGSize(width: customTabbar.frame.width, height: buttonHeight)
        tabbarBgImageView.center.x = customTabbar.bounds.midX
        tabbarBgImageView.center.y = tabbarItemHeight - (buttonHeight / 2)
        
        customTabbar.addSubview(tabbarBgImageView)
        customTabbar.sendSubviewToBack(tabbarBgImageView)
    }
    
    @objc func showViewController() {
        self.selectedIndex = 2
        
//        print("點擊KOKO")
    }
    
}
