//
//  UserRateDTO.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/9/21.
//

import Foundation

struct UserRateDTO: Encodable {
    var star: Int
    var order: Int
    var comment: String?
    var sample: [Int]?

    enum CodingKeys: String, CodingKey {
        case star, order, comment
        case sample = "rate_samples"
    }
}

struct UserRateResponseContainer: Codable {
    let data: UserRateResponse?
    let error: ErrorResponse?
}

struct UserRateResponse: Codable {
    var star: Int
    var order: Int
    var comment: String?
    var sample: [Int]?
    let error: ErrorResponse?

    enum CodingKeys: String, CodingKey {
        case star, order, comment
        case sample = "rate_samples"
        case error
    }
}
