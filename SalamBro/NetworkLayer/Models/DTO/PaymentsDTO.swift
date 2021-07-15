//
//  PaymentsDTO.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation

struct CreateOrderDTO: Codable {
    let leadUUID: String

    enum CodingKeys: String, CodingKey {
        case leadUUID = "lead"
    }
}

struct CreatePaymentDTO: Encodable {
    let leadUUID: String
    let paymentType: String
    let cryptogram: String
    let cardholderName: String

    enum CodingKeys: String, CodingKey {
        case leadUUID = "lead"
        case paymentType = "payment_type"
        case cryptogram
        case cardholderName = "card_holder_name"
    }
}
