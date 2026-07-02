//
//  InviteSectionView.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import UIKit

protocol InviteSectionViewDelegate: AnyObject {
    func didClickItemView()
    func didClickCheckButton()
    func didClickCancelButton()
}

class InviteSectionView: UIView {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var backgroundViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var itemView: UIView!
    @IBOutlet private weak var itemUnderView: UIView!
    @IBOutlet private weak var itemUnderViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Property
    
    weak var delegate: InviteSectionViewDelegate? = nil
    
    // MARK: - Life Cycle.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLayout()
    }
    
    func configureUI(name: String, isFirst: Bool, inviteSectionFoldState: FriendListViewController.FoldState) {
        backgroundViewTopConstraint.constant = isFirst ? 25 : 0
        backgroundViewBottomConstraint.constant = isFirst ? 10 : 15
        
        nameLabel.text = name
        
        itemUnderView.isHidden = inviteSectionFoldState == .unfold
        itemUnderViewConstraint.constant = inviteSectionFoldState == .unfold ? 0 : 70
    }
    
    func updateUI(inviteSectionFoldState: FriendListViewController.FoldState) {
        itemUnderView.isHidden = inviteSectionFoldState == .unfold
        itemUnderViewConstraint.constant = inviteSectionFoldState == .unfold ? 0 : 70
    }
    
}

// MARK: - Configure

private extension InviteSectionView {
    
    func configureLayout() {
        itemView.layer.cornerRadius = 16
        itemView.configureShadow()
        itemUnderView.layer.cornerRadius = 16
        itemUnderView.configureShadow()
        
        headImageView.layer.cornerRadius = headImageView.frame.height / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        itemView.addGestureRecognizer(tapGesture)
        itemView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap() {
        delegate?.didClickItemView()
    }
    
}

// MARK: - @IBAction

private extension InviteSectionView {
    
    @IBAction func didClickCheckButton(_ sender: Any) {
        delegate?.didClickCheckButton()
    }
    @IBAction func didClickCancelButton(_ sender: Any) {
        delegate?.didClickCancelButton()
    }
    
}

// MARK: - NibInitializable.

extension InviteSectionView: NibInitializable {}
