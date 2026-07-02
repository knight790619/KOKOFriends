//
//  APIEndpoint.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation
import Alamofire

enum APIEndpoint {
    /// 使用者資料
    case user
    /// 好友列表1
    case friend1
    /// 好友列表2
    case friend2
    /// 好友列表含邀請列表
    case friend3
    /// 無資料邀請/好友列表
    case friend4
    
    var baseURL: String {
        "https://dimanyen.github.io"
    }
    
    var path: String {
        switch self {
        case .user:
            return "/man.json"
        case .friend1:
            return "/friend1.json"
        case .friend2:
            return "/friend2.json"
        case .friend3:
            return "/friend3.json"
        case .friend4:
            return "/friend4.json"
        }
    }
    
    var url: URL {
        guard let url = URL(string: baseURL + path) else {
            fatalError("Invalid URL: \(baseURL + path)")
        }
        return url
    }
    
    var method: HTTPMethod {
        .get
    }
}
