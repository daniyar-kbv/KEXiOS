//
//  Promotions.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation

struct PromotionResult: Codable {
    let promotions: [Promotion]
    let verificationURL: String

    enum CodingKeys: String, CodingKey {
        case promotions
        case verificationURL = "instagram_verification_url"
    }
}

struct Promotion: Codable {
    let priority: Int
    let id: Int
    let promoType: String
    let name: String
    let description: String
    let image: String
    let slug: String
    let link: String?

    enum CodingKeys: String, CodingKey {
        case priority, id, name, image, slug, link, description
        case promoType = "promo_type"
    }
}
