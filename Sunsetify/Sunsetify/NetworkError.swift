//
//  NetworkError.swift
//  Sunsetify
//
//  Created by Johnson, Courtney M on 2/8/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case generalError
}
