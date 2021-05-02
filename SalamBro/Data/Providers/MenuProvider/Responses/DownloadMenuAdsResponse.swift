//
//  DownloadMenuAdsResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public final class DownloadMenuAdsResponse: Decodable {
    public var menuAds: [Ad]
    
    // MOCK: - remove
    public init(menuAds: [Ad]) {
        self.menuAds = menuAds
    }
}

// MOCK: - remove
extension DownloadMenuAdsResponse {
    public static var mockReponse: DownloadMenuAdsResponse {
        .init(menuAds: getMenuAds())
    }
    
    private static func getMenuAds() -> [Ad] {
        var temp: [Ad] = []
        for i in 0..<9 {
            temp.append(Ad(name: "ad\(i)"))
        }
        return temp
    }
}
