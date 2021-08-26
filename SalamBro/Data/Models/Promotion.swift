//
//  Promotions.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation

struct PromotionResult: Codable {
    let promotions: [Promotion]
    let redirectURL: String
    let verificationURL: String
    let parameterName: String

    enum CodingKeys: String, CodingKey {
        case promotions
        case redirectURL = "instagram_redirect_url"
        case verificationURL = "instagram_verification_url"
        case parameterName = "instagram_parameter"
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
