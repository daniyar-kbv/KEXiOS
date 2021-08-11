//
//  AuthResponse.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import Foundation

struct RegisterResponse: Codable {
    let error: ErrorResponse?
}

struct AccessTokenResponse: Codable {
    let data: AccessToken?
    let error: ErrorResponse?
}

struct RefreshTokenResponse: Codable {
    let access: String
    let refresh: String
}

struct AccessToken: Codable {
    let secretKey: String?
    let refresh: String
    let access: String

    enum CodingKeys: String, CodingKey {
        case secretKey = "secret_key"
        case refresh
        case access
    }
}
