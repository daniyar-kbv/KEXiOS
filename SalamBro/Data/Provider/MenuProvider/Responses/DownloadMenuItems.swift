//
//  DownloadMenuItems.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public struct DownloadMenuItemsResponse: Decodable {
    public var menuItems: [FoodDTO]
}

extension DownloadMenuItemsResponse {
    public static var mockResponse: DownloadMenuItemsResponse {
        .init(menuItems: getMenuItems())
    }

    private static func getMenuItems() -> [FoodDTO] {
        var temp: [FoodDTO] = []
        for i in 0 ..< 9 {
            temp.append(FoodDTO(id: i, title: "Бургер\(i)", price: 1490, description: "Двойной чизбургер (говяжий/куриный), картофель фри, напиток на выбор"))
        }
        return temp
    }
}
