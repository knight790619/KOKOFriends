//
//  FriendListViewModel.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation

class FriendListViewModel {
    
    // MARK: - Closure
    
    var onLoading: (() -> Void)?
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onRefreshSuccess: (() -> Void)?
    var onRefreshError: ((String) -> Void)?
    
    // MARK: - API
    
    private let apiService: APIServiceProtocol
    
    // MARK: - Data
    
    private(set) var user: User?
    
    /// status == 0，給好友邀請區使用
    private(set) var inviteFriends: [Friend] = []
    
    /// status == 1 或 2，給好友列表使用
    private(set) var friends: [Friend] = []
    
    /// status == 2，邀請中的人數
    private(set) var invitingFriendsCount: Int = 0
    
    /// 搜尋後的好友列表
    private(set) var filteredFriends: [Friend] = []
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Load Data
    
    func loadData(viewType: FriendListViewController.FriendListViewType) {
        onLoading?()
        
        Task {
            do {
                let user = try await apiService.fetchUser()
                let allFriends = try await fetchFriends(viewType: viewType)
                
                await MainActor.run {
                    self.user = user
                    self.handleFriends(allFriends)
                    
                    self.onSuccess?()
                }
            } catch {
                await MainActor.run {
                    self.onError?("資料載入失敗")
                }
            }
        }
    }
    
    // MARK: - 下拉刷新
    
    func refreshData(viewType: FriendListViewController.FriendListViewType) {
        Task {
            do {
                let allFriends = try await fetchFriends(viewType: viewType)
                
                await MainActor.run {
                    self.handleFriends(allFriends)
                    self.onRefreshSuccess?()
                }
            } catch {
                await MainActor.run {
                    self.onRefreshError?("刷新失敗")
                }
            }
        }
    }
    
    // MARK: - Search
    
    func search(keyword: String) {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyword.isEmpty {
            filteredFriends = []
        } else {
            filteredFriends = friends.filter { friend in
                friend.name.contains(keyword)
            }
        }
    }
    
}

private extension FriendListViewModel {
    
    func fetchFriends(viewType: FriendListViewController.FriendListViewType) async throws -> [Friend] {
        switch viewType {
            
        case .noFriend:
            // man.json + friend4.json
            return try await apiService.fetchFriend4()
            
        case .normalFriend:
            // man.json + friend1.json + friend2.json
            // 同時打 firen1 + friend2
            async let friend1 = apiService.fetchFriend1()
            async let friend2 = apiService.fetchFriend2()
            
            let (result1, result2) = try await (friend1, friend2)
            return result1 + result2
            
        case .friendWithInvite:
            // man.json + friend3.json
            return try await apiService.fetchFriend3()
        }
    }
    
    func handleFriends(_ allFriends: [Friend]) {
        // 處理重複 user 並保留最新 updateDate 那筆
        let mergedFriends = mergeDuplicatedFriends(allFriends)
        
        // 依 status 拆分
        inviteFriends = mergedFriends.filter { friend in
            friend.status == .inviteReceived
        }
        
        friends = mergedFriends.filter { friend in
            friend.status == .completed || friend.status == .inviting
        }
        
        // 好友 badgeCount 人數
        invitingFriendsCount = friends.filter({$0.status == .inviting}).count
        
        // 好友列表排序
        friends = sortFriends(friends)
        
        // 預設搜尋結果就是全部好友
        filteredFriends = friends
    }
    
    func mergeDuplicatedFriends(_ friends: [Friend]) -> [Friend] {
        var result: [Friend] = []
        
        for friend in friends {
            // 檢查是否有相同 id
            if let index = result.firstIndex(where: { $0.fid == friend.fid }) {
                let oldFriend = result[index]
                // 比較日期保留新的
                if friend.normalizedUpdateDate > oldFriend.normalizedUpdateDate {
                    result[index] = friend
                }
            } else {
                // 沒有重複 id，直接加入
                result.append(friend)
            }
        }
        
        return result
    }
    
    func sortFriends(_ friends: [Friend]) -> [Friend] {
        return friends.sorted { first, second in
            /*
             排序順序
             1. 邀請中 status == .inviting -> 2. 最愛 isTop == true -> 3. id
             */
            
            if first.status != second.status {
                if first.status == .inviting { return true }
                if second.status == .inviting { return false }
            }
            
            if first.isTop != second.isTop {
                return first.isTop
            }
            
            return first.fid < second.fid
        }
    }
    
}
