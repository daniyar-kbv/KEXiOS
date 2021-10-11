//
//  Order.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/12/21.
//

import Foundation

struct OrdersList: Decodable {
    let id: Int
    let brand: Brand
    let address: Address
    let cart: Cart
    let price: String
    let createdDate: String
    let status: String
    let paymentType: String
    let statusReason: String?
    let leadID: String
    let checkURL: String

    enum CodingKeys: String, CodingKey {
        case id, brand, address, cart, price, status
        case createdDate = "created_at"
        case paymentType = "payment_type"
        case statusReason = "status_reason"
        case leadID = "lead_id"
        case checkURL = "check_url"
    }
}

enum OrderedFoodStatus: String, Codable {
    case new = "NEW"
    case paid = "PAID"
    case applying = "APPLYING"
    case applyError = "APPLY_ERROR"
    case applied = "APPLIED"
    case unconfirmed = "UNCONFIRMED"
    case readyForCooking = "READY_FOR_COOKING"
    case started = "COOKING_STARTED"
    case completed = "COOKING_COMPLETED"
    case waiting = "WAITING"
    case onWay = "ON_WAY"
    case delivered = "DELIVERED"
    case done = "DONE"
    case canceled = "CANCELED"

    var title: String {
        switch self {
        case .new, .paid, .applying, .applyError, .applied, .unconfirmed, .readyForCooking:
            return SBLocalization.localized(key: ProfileText.OrderHistory.applying)
        case .started, .completed:
            return SBLocalization.localized(key: ProfileText.OrderHistory.started)
        case .waiting:
            return SBLocalization.localized(key: ProfileText.OrderHistory.waiting)
        case .onWay:
            return SBLocalization.localized(key: ProfileText.OrderHistory.onWay)
        case .delivered, .done:
            return SBLocalization.localized(key: ProfileText.OrderHistory.delivered)
        case .canceled:
            return SBLocalization.localized(key: ProfileText.OrderHistory.canceled)
        }
    }
}
