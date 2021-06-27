//
//  CitiesResponse.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

struct CitiesResponse: Decodable {
    let data: ResponseData?
    let error: ErrorResponse?

    struct ResponseData: Decodable {
        let name: String
        let cities: [City]
    }
}
