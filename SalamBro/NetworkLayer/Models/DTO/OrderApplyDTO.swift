//
//  OrderApplyDTO.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation

struct OrderApplyDTO: Codable {
    let address: Address
    let localBrand: Int

    enum CodingKeys: String, CodingKey {
        case address
        case localBrand = "local_brand"
    }
}
