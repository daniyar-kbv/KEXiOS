//
//  PromotionsResponse.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

struct PromotionsResponse: Decodable {
    let data: ResponseData?
    let error: ErrorResponse?

    struct ResponseData: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Promotion]
    }
}

struct PromotionDetailResponse: Decodable {
    let data: Promotion?
    let error: ErrorResponse?
}
