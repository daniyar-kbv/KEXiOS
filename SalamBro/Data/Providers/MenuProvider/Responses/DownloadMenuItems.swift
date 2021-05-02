//
//  DownloadMenuItems.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public final class DownloadMenuItemsResponse: Decodable {
    public var menuItems: [Food]
    
    // MOCK: - remove
    public init(menuItems: [Food]) {
        self.menuItems = menuItems
    }
}

extension DownloadMenuItemsResponse {
    public static var mockResponse: DownloadMenuItemsResponse {
        .init(menuItems: getMenuItems())
    }
    
    private static func getMenuItems() -> [Food] {
        var temp: [Food] = []
        for i in 0..<9 {
            temp.append(Food(id: i, title: "Бургер\(i)", price: 1490, description: "Двойной чизбургер (говяжий/куриный), картофель фри, напиток на выбор"))
        }
        return temp
    }
}
