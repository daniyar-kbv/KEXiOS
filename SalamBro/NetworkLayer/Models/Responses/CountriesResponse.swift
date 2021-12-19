//
//  CountriesResponse.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 26.05.2021.
//

import Foundation

struct CountriesResponse: Decodable {
    let data: [Country]?
    let error: ErrorResponse?
}
