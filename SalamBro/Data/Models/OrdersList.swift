//
//  Order.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/12/21.
//

import Foundation

struct OrdersList: Codable {
    let id: Int
    let brand: Brand
    let address: Address
    let cart: Cart
    let price: String
    let createdDate: String
    let status: OrderedFoodStatus
    let paymentType: PaymentMethodType
    let statusReason: String
    let leadID: String

    enum CodingKeys: String, CodingKey {
        case id, brand, address, cart, price, status
        case createdDate = "created_at"
        case paymentType = "payment_type"
        case statusReason = "status_reason"
        case leadID = "lead_id"
    }
}

enum OrderedFoodStatus: String, Codable {
    case new = "NEW"
    case paid = "PAID"
    case cooking = "COOKING"
    case inDelivery = "IN_DELIVERY"
    case issued = "ISSUED"
    case failure = "FAILURE"
}
