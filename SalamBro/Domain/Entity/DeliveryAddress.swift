//
//  DeliveryAddress.swift
//  SalamBro
//
//  Created by Dan on 6/10/21.
//

import Foundation

public struct DeliveryAddress: Codable {
    var country: Country?
    var city: City?
    var address: Address?
}

extension DeliveryAddress {
    func isComplete() -> Bool {
        return country != nil && city != nil && address != nil
    }
}

extension DeliveryAddress: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.address == rhs.address
    }
}
