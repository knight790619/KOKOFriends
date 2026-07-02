//
//  StoryboardScene.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/29.
//

import UIKit

enum StoryboardScene {
    
    static var mainTabbar: MainTabbarController {
        let storyboard = UIStoryboard(name: "MainTabbar", bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? MainTabbarController else {
            fatalError("Cannot instantiate MainTabbarController from MainTabbar.storyboard")
        }
        
        return viewController
    }
    
    static var loginView: UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else {
            fatalError("Cannot instantiate ViewController from Main.storyboard")
        }
        
        return viewController
    }
    
}
