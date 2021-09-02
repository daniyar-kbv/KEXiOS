//
//  DocumentsResponses.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation

struct DocumentsResponse: Codable {
    let data: [Document]?
    let error: ErrorResponse?
}

struct ContactsResponse: Codable {
    let data: [Contact]?
    let error: ErrorResponse?
}
