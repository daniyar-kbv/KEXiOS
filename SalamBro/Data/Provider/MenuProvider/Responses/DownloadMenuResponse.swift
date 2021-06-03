//
//  DownloadBrandListResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public struct DownloadMenuCategoriesResponse: Decodable {
    public var categories: [FoodTypeDTO]
}

// MOCK: - remove
extension DownloadMenuCategoriesResponse {
    public static var mockResponse: DownloadMenuCategoriesResponse {
        .init(categories: getMenuCategories())
    }

    private static func getMenuCategories() -> [FoodTypeDTO] {
        var temp: [FoodTypeDTO] = []
        let titles = [L10n.Menu.Categories.combo, L10n.Menu.Categories.burgers, L10n.Menu.Categories.hotdogs, L10n.Menu.Categories.drinks, L10n.Menu.Categories.sauces, L10n.Menu.Categories.other]
        for i in 0 ..< 6 {
            var tempItems: [FoodDTO] = []
            for j in 0 ..< 9 {
                tempItems.append(FoodDTO(id: i, title: "\(titles[i]) \(j)", price: 1490, description: "Двойной чизбургер (говяжий/куриный), картофель фри, напиток на выбор"))
            }
            temp.append(FoodTypeDTO(title: titles[i], position: i, foods: tempItems))
        }
        return temp
    }
}
