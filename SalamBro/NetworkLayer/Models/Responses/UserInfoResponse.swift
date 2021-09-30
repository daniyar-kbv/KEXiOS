//
//  UserInfoResponse.swift
//  SalamBro
//
//  Created by Dan on 7/23/21.
//

import Foundation

struct UserInfoResponseContainer: Codable {
    let data: UserInfoResponse?
    let error: ErrorResponse?
}

struct UserInfoResponse: Codable {
    let name: String?
    let email: String?
    let mobilePhone: String?

    enum CodingKeys: String, CodingKey {
        case name, email
        case mobilePhone = "mobile_phone"
    }
}

struct UserAddressesResponse: Decodable {
    let data: [UserAddress]?
    let error: ErrorResponse?
}
