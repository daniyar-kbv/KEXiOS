//
//  AuthDTO.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import Foundation

struct SendOTPDTO: Encodable {
    var phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "mobile_phone"
    }
}

struct OTPVerifyDTO: Encodable {
    let code: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case code
        case phoneNumber = "mobile_phone"
    }
}

struct RefreshDTO: Encodable {
    let refresh: String
}
