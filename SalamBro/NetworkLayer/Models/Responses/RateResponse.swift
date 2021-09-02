//
//  RateResponse.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/12/21.
//

import Foundation

struct RateResponseContainer: Codable {
    let data: [RateStarList]?
    let error: ErrorResponse?
}
