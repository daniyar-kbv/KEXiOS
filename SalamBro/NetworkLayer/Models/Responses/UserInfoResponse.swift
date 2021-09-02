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
    let error: ErrorResponse?

    enum CodingKeys: String, CodingKey {
        case name, email
        case mobilePhone = "mobile_phone"
        case error
    }
}

struct UserAddressesResponse: Decodable {
    let data: [UserAddress]?
    let error: ErrorResponse?
}

struct UpdateUserAddressResponse: Decodable {
    let data: UpdateAddressDTO?
    let error: ErrorResponse?
}
