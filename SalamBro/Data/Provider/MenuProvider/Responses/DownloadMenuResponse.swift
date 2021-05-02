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
        let titles = ["combos", "sushi", "burgers", "doners", "template", "template", "template", "template", "template"]
        for i in 0 ..< 9 {
            temp.append(FoodTypeDTO(title: titles[i], position: i, foods: []))
        }
        return temp
    }
}
