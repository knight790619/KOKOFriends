//
//  PageState.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/7/1.
//

class PageState {
    static let shared = PageState()
    private init() {}

    var state: FriendListViewController.FriendListViewType = .noFriend
}
