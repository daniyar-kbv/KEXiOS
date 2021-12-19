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

struct UpdateAddressDTO: Codable {
    let id: Int
    let brandId: Int?

    enum CodingKeys: String, CodingKey {
        case id = "user_address"
        case brandId = "local_brand"
    }
}
