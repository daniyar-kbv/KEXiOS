//
//  DownloadMenuAdsResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public struct DownloadMenuAdsResponse: Decodable {
    public var menuAds: [AdDTO]
}

// MOCK: - remove
extension DownloadMenuAdsResponse {
    public static var mockReponse: DownloadMenuAdsResponse {
        .init(menuAds: getMenuAds())
    }

    private static func getMenuAds() -> [AdDTO] {
        var temp: [AdDTO] = []
        for i in 0 ..< 9 {
            temp.append(AdDTO(name: "ad\(i)"))
        }
        return temp
    }
}
