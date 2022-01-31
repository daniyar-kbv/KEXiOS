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
        let page: Int
        let totalPages: Int
        let results: PromotionResult

        enum CodingKeys: String, CodingKey {
            case count, page, results
            case totalPages = "total_pages"
        }
    }
}

struct PromotionDetailResponse: Decodable {
    let data: Promotion?
    let error: ErrorResponse?
}
