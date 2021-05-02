//
//  DownloadCitiesResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

public struct DownloadCitiesResponse: Decodable {
    public var cities: [String]
}

// MOCK: - remove
public extension DownloadCitiesResponse {
    static var mockResponse: DownloadCitiesResponse {
        .init(cities: ["Nur-Sultan", "Almaty", "Karaganda", "Atyrau", "Aktobe"])
    }
}
