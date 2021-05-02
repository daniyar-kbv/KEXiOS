//
//  DownloadCountriesReponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

public struct DownloadCountriesReponse: Decodable {
    public var countries: [CountryDTO]
}

// MOCK: - remove
extension DownloadCountriesReponse {
    public static var mockResponse: DownloadCountriesReponse {
        .init(countries: getCountries())
    }

    private static func getCountries() -> [CountryDTO] {
        var temp: [CountryDTO] = []
        let ids = [1, 2, 3]
        let names = ["Kazakhstan", "Russian Federation", "United Stated of America"]
        let callingCodes = ["+7", "+7", "+1"]
        for i in 0 ..< ids.count {
            temp.append(CountryDTO(id: ids[i],
                                   name: names[i],
                                   callingCode: callingCodes[i]))
        }
        return temp
    }
}
