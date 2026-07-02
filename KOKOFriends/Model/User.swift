//
//  User.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation

struct UserResponse: Decodable {
    let response: [User]
}

struct User: Decodable {
    let name: String
    let kokoid: String
}
