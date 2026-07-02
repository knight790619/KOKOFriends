//
//  ViewController.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/29.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didClickNoFriendButton(_ sender: UIButton) {
        PageState.shared.state = .noFriend
        switchToMainTabbar(animated: true)
    }
    
    @IBAction func didClickNormalFriendButton(_ sender: Any) {
        PageState.shared.state = .normalFriend
        switchToMainTabbar(animated: true)
    }
    
    @IBAction func didClickFriendWithInviteButton(_ sender: Any) {
        PageState.shared.state = .friendWithInvite
        switchToMainTabbar(animated: true)
    }
    
    func switchToMainTabbar(animated: Bool) {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.switchToMainTabbar(animated: animated)
        }
    }
}
