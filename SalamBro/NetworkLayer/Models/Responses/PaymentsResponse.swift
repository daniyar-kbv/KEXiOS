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
