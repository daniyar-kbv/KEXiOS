//
//  Payment.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation

protocol OrderStatusProtocol: AnyObject {
    var uuid: String { get }
    var transactionId: String { get }
    var paReq: String? { get }
    var acsURL: String? { get }
    var status: String { get }
    var statusReason: String? { get }
}

extension OrderStatusProtocol {
    func determineStatus() -> OrderStatus.StatusType? {
        return OrderStatus.StatusType(rawValue: status)
    }
}

class OrderStatus: OrderStatusProtocol, Decodable {
    let uuid: String
    let transactionId: String
    let paReq: String?
    let acsURL: String?
    let status: String
    let statusReason: String?

    enum CodingKeys: String, CodingKey {
        case uuid, status
        case transactionId = "outer_id"
        case paReq = "pa_req"
        case acsURL = "acs_url"
        case statusReason = "status_reason"
    }
}

extension OrderStatus {
    enum StatusType: String {
        case new = "NEW"
        case completed = "COMPLETED"
        case canceled = "CANCELLED"
        case declined = "DECLINED"
        case awaitingAuthentication = "AWAITING_AUTHENTICATION"
    }
}

class CardPaymentOrderStatus: OrderStatusProtocol, Decodable {
    let uuid: String
    let transactionId: String
    let paReq: String?
    let acsURL: String?
    let status: String
    let statusReason: String?
    let cardUUID: String

    enum CodingKeys: String, CodingKey {
        case uuid, status
        case transactionId = "outer_id"
        case paReq = "pa_req"
        case acsURL = "acs_url"
        case statusReason = "status_reason"
        case cardUUID = "debit_card"
    }
}

struct MyCard: Decodable {
    let uuid: String
    let cardHolderName: String
    let cardMaskedNumber: String
    let cardExpirationDate: String
    let cardType: String

    enum CodingKeys: String, CodingKey {
        case uuid
        case cardHolderName = "card_holder_name"
        case cardMaskedNumber = "card_masked_number"
        case cardExpirationDate = "card_expiration_date"
        case cardType = "card_type"
    }
}

extension MyCard: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct PaymentCard {
    let cryptogram: String
    let cardholderName: String
    let needsSave: Bool
}

extension PaymentCard: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.cryptogram == rhs.cryptogram
    }
}
