//
//  APIConstants.swift
//  Sungram
//
//  Created by Johnson, Courtney M on 2/8/25.
//

import Foundation


enum APIConstants {
    static let apiHost = "api.spotify.com"
    static let authHost = "accounts.spotify.com"
    static let clientId = "0778aa32b89e4f4b8ae03776cf4f8b8c"
    static let clientSecret = "524dc584008544a0b2aee9db62a22466"
    static let redirectUri = "https://www.google.com"
    static let responseType = "token"
    static let scopes = "user-read-private"
    
    static var authParams = [
            "response_type": responseType,
            "client_id": clientId,
            "redirect_uri": redirectUri,
            "scope": scopes
        ]

   
}

