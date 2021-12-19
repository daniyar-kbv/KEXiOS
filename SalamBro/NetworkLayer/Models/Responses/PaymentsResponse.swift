//
//  PaymentsResponse.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation

struct CreateOrderResponse: Decodable {
    let data: CreateOrderDTO?
    let error: ErrorResponse?
}

struct PaymentResponse: Decodable {
    var data: PaymentStatus?
    var error: ErrorResponse?
}

struct MyCardsResponse: Decodable {
    let data: [MyCard]?
    let error: ErrorResponse?
}

struct DeleteCardResponse: Decodable {
    let error: ErrorResponse?
}
