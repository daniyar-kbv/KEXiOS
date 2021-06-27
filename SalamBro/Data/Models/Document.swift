//
//  Document.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation

struct Document: Codable {
    let priority: Int
    let id: Int
    let name: String
    let slug: String
    let link: String
}
