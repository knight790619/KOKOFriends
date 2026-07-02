//
//  APIService.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation
import Alamofire

class APIService: APIServiceProtocol {

    private let session: Session

    init(session: Session = APIService.makeSession()) {
        self.session = session
    }

    func fetchUser() async throws -> User {
        let response: UserResponse = try await request(.user)

        guard let user = response.response.first else {
            throw APIError.emptyUser
        }

        return user
    }

    func fetchFriend1() async throws -> [Friend] {
        let response: FriendResponse = try await request(.friend1)
        return response.response
    }

    func fetchFriend2() async throws -> [Friend] {
        let response: FriendResponse = try await request(.friend2)
        return response.response
    }

    func fetchFriend3() async throws -> [Friend] {
        let response: FriendResponse = try await request(.friend3)
        return response.response
    }

    func fetchFriend4() async throws -> [Friend] {
        let response: FriendResponse = try await request(.friend4)
        return response.response
    }

    private func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        do {
            return try await session
                .request(endpoint.url, method: endpoint.method)
                .validate(statusCode: 200..<300)
                .serializingDecodable(T.self)
                .value
        } catch {
            throw APIError.unknown(error)
        }
    }

    private static func makeSession() -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        configuration.headers = .default

        return Session(configuration: configuration)
    }
}
