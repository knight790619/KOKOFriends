//
//  Friend.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation

struct FriendResponse: Decodable {
    let response: [Friend]
}

struct Friend: Decodable, Hashable {
    let name: String
    let status: FriendStatus
    let isTop: Bool
    let fid: String
    let updateDate: String

    enum CodingKeys: String, CodingKey {
        case name
        case status
        case isTop
        case fid
        case updateDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(FriendStatus.self, forKey: .status)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.updateDate = try container.decode(String.self, forKey: .updateDate)

        let isTopString = try container.decode(String.self, forKey: .isTop)
        self.isTop = (isTopString == "1")
    }
}

enum FriendStatus: Int, Decodable {
    /// status: 0 邀請送出 (inviteView 顯示))
    case inviteReceived = 0
    /// status: 1 已完成
    case completed = 1
    /// status: 2 邀請中 ( tableView 置頂)
    case inviting = 2
}

extension Friend {
    var normalizedUpdateDate: String {
        return updateDate.replacingOccurrences(of: "/", with: "")
    }
}
