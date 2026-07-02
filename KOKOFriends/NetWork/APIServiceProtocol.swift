//
//  APIServiceProtocol.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation

protocol APIServiceProtocol {
    func fetchUser() async throws -> User
    func fetchFriend1() async throws -> [Friend]
    func fetchFriend2() async throws -> [Friend]
    func fetchFriend3() async throws -> [Friend]
    func fetchFriend4() async throws -> [Friend]
}
