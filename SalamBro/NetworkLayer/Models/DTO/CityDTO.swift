//
//  CityDTO.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/1/21.
//

import Foundation

struct CityDTO: Encodable {
    let name: String
    let cities: [City]

    enum CodingKeys: String, CodingKey {
        case name
        case cities
    }
}

struct CityResponseContainer: Codable {
    let data: CityResponse?
    let error: ErrorResponse?
}

struct CityResponse: Codable {
    let name: String
    let cities: [City]
    let error: ErrorResponse?

    enum CodingKeys: String, CodingKey {
        case name
        case cities
        case error
    }
}
