//
//  UserInfoDTO.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 14.06.2021.
//

import Foundation

struct UserInfoDTO: Encodable {
    var name: String?
    var email: String?
    var mobilePhone: String?

    enum CodingKeys: String, CodingKey {
        case name, email
        case mobilePhone = "mobile_phone"
    }
}

struct UserInfoResponseContainer: Codable {
    let data: UserInfoResponse
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
