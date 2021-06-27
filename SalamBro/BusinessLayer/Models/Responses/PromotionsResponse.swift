//
//  PromotionsResponse.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

struct PromotionsResponse: Codable {
    let data: ResponseData?
    let error: ErrorResponse?

    struct ResponseData: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Promotion]
    }
}
