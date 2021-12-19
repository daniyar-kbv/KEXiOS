//
//  Promocode.swift
//  SalamBro
//
//  Created by Dan on 8/6/21.
//

import Foundation

struct Promocode: Decodable {
    let group: String
    let promocode: String
    let description: String
    let startData: String
    let endDate: String

    enum CodingKeys: String, CodingKey {
        case group, promocode, description
        case startData = "start_date"
        case endDate = "end_date"
    }
}
