//
//  FriendTableViewCell.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/7/1.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var headImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var transferBackgroundView: UIView!
    @IBOutlet private weak var transferButton: UIButton!
    @IBOutlet private weak var invitingBackgroundView: UIView!
    @IBOutlet private weak var invitingButton: UIButton!
    @IBOutlet private weak var moreButtonBackgroundView: UIView!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var underLineView: UIView!
    
    // MARK: - Properties
    
    static let nibName = "FriendCell"
    static let identifier = "FriendTableViewCell"
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureLayout()
    }
    
    func configureUI(friend: Friend) {
        starImageView.isHidden = !friend.isTop
        
        nameLabel.text = friend.name
        
        switch friend.status {
        case .inviting:
            invitingBackgroundView.isHidden = false
            moreButtonBackgroundView.isHidden = true
        default:
            invitingBackgroundView.isHidden = true
            moreButtonBackgroundView.isHidden = false
        }
    }
    
}

// MARK: - Configure

private extension FriendTableViewCell {
    
    func configureLayout() {
        transferBackgroundView.layer.cornerRadius = 2
        invitingBackgroundView.layer.cornerRadius = 2
        
        transferBackgroundView.layer.borderColor = UIColor.hotPink.cgColor
        transferBackgroundView.layer.borderWidth = 1.2
        
        invitingBackgroundView.layer.borderColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        invitingBackgroundView.layer.borderWidth = 1.2
        
        underLineView.layer.cornerRadius = 1
    }
    
}

// MARK: - @IBAction

private extension FriendTableViewCell {
    
    @IBAction func didClickTransferButton(_ sender: Any) {
    }
    
    @IBAction func didClickInvitingButton(_ sender: Any) {
    }
    
    @IBAction func didClickMoreButton(_ sender: Any) {
    }
    
}
