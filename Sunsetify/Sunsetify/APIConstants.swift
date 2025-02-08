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
    static let clientId = "67e749ccfaff40c9ad7e293e69838922"
    static let clientSecret = "5be9b067330d42558192c97f86128512"
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

