//
//  RateResponse.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/12/21.
//

import Foundation

struct RateResponseContainer: Codable {
    let data: RateResponse?
    let error: ErrorResponse?
}

struct RateResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [RateStarList]

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
    }
}
