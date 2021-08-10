//
//  PromocodeResponse.swift
//  SalamBro
//
//  Created by Dan on 8/6/21.
//

import Foundation

struct PromocodeResponse: Decodable {
    let data: Promocode?
    let error: ErrorResponse?
}
