//
//  BrandResponse.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

struct BrandResponse: Decodable {
    let data: [Brand]
    let error: String?
}
