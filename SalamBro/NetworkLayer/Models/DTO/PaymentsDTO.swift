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
    let cryptogram: String?
    let cardholderName: String?
    let keepCard: Bool?

    enum CodingKeys: String, CodingKey {
        case leadUUID = "lead"
        case paymentType = "payment_type"
        case cryptogram
        case cardholderName = "card_holder_name"
        case keepCard = "keep_card"
    }
}

struct Create3DSPaymentDTO: Encodable {
    let paRes: String
    let transactionId: String

    enum CodingKeys: String, CodingKey {
        case paRes = "pa_res"
        case transactionId = "outer_id"
    }
}

struct CardPaymentDTO: Encodable {
    let leadUUID: String
    let cardUUID: String

    enum CodingKeys: String, CodingKey {
        case leadUUID = "lead"
        case cardUUID = "debit_card"
    }
}
