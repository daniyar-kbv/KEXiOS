//
//  PromotionsDTO.swift
//  SalamBro
//
//  Created by Dan on 8/26/21.
//

import Foundation

struct PromotionsParticipateDTO: Codable {
    let promotionId: Int
    let code: String

    enum CodingKeys: String, CodingKey {
        case code
        case promotionId = "promotion"
    }
}
