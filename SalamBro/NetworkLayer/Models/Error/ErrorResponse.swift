//
//  ErrorResponse.swift
//  SalamBro
//
//  Created by Dan on 11/1/21.
//

import Foundation

struct ResponseWithErrorOnly: Decodable {
    let error: ErrorResponse
}
