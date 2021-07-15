//
//  RateDTO.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/9/21.
//

import Foundation

struct RateStarList: Codable {
    var id: Int
    var value: Int
    var title: String
    var description: String
    var samples: [RateSample]

    enum CodingKeys: String, CodingKey {
        case id, value, title, description
        case samples = "rate_samples"
    }
}

struct RateSample: Codable {
    var id: Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
