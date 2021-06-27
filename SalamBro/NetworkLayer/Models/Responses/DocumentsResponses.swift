//
//  DocumentsResponses.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation

struct DocumentsResponse: Codable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Document]
    }
}

struct ContactsResponse: Codable {
    let data: [Contact]?
    let error: ErrorResponse?
}
