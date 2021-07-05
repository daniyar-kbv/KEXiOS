//
//  Promotions.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation

struct Promotion: Codable {
    let priority: Int
    let id: Int
    let name: String
    let image: String
    let slug: String
    let link: String
}
