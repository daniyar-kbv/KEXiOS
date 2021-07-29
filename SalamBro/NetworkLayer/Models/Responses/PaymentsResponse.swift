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

struct CreatePaymentResponse: Decodable {
    let data: OrderStatus?
    let error: ErrorResponse?
}

struct MyCardsResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [MyCard]
    }
}

struct DeleteCardResponse: Decodable {
    let data: MyCard?
    let error: ErrorResponse?
}

struct CardPaymentResponse: Decodable {
    let data: CardPaymentOrderStatus?
    let error: ErrorResponse?
}
