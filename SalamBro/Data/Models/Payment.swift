//
//  Payment.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation

struct OrderStatus: Decodable {
    let order: Int
    let status: String
    let statusReason: String

    enum CodingKeys: String, CodingKey {
        case order, status
        case statusReason = "status_reason"
    }
}

extension OrderStatus {
    func determineStatus() -> StatusType? {
        return StatusType(rawValue: status)
    }

    enum StatusType: String {
        case completed = "COMPLETED"
        case canceled = "CANCELLED"
        case declined = "DECLINED"
    }
}

struct SavedCard {
    let id: Int
    let lastFourDigits: String
}

extension SavedCard: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id &&
            lhs.lastFourDigits == rhs.lastFourDigits
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
