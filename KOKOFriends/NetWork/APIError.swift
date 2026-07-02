//
//  APIError.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/30.
//

import Foundation

enum APIError: Error, LocalizedError {
    case emptyUser
    case invalidResponse
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .emptyUser:
            return "使用者資料不存在"
        case .invalidResponse:
            return "伺服器回應格式錯誤"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
