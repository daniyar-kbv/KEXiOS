//
//  BrandResponse.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

struct BrandResponse: Decodable {
    let data: ResponseData
    let error: String?

    struct ResponseData: Decodable {
        let count: Int
        let next: Int?
        let previous: Int?
        let results: [Brand]
    }
}
