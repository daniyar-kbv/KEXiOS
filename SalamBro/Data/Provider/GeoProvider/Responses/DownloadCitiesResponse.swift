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
        .init(cities: [L10n.Cities.almaty, L10n.Cities.nursultan, L10n.Cities.aktobe, L10n.Cities.taldykorgan, L10n.Cities.uralsk, L10n.Cities.aktau, L10n.Cities.taraz])
    }
}
