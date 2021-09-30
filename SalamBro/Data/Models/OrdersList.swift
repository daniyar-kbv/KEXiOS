//
//  Order.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/12/21.
//

import Foundation

struct OrdersList: Decodable {
    let id: Int
    let brand: HistoryBrand
    let address: Address
    let cart: Cart
    let price: String
    let createdDate: String
    let status: String
    let paymentType: String
    let statusReason: String?
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

    var title: String {
        switch self {
        case .new:
            return SBLocalization.localized(key: ProfileText.OrderHistory.new)
        case .paid:
            return SBLocalization.localized(key: ProfileText.OrderHistory.paid)
        case .cooking:
            return SBLocalization.localized(key: ProfileText.OrderHistory.cooking)
        case .inDelivery:
            return SBLocalization.localized(key: ProfileText.OrderHistory.inDelivery)
        case .issued:
            return SBLocalization.localized(key: ProfileText.OrderHistory.issued)
        case .failure:
            return SBLocalization.localized(key: ProfileText.OrderHistory.failure)
        }
    }
}
