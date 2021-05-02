//
//  DownloadBrandListResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public class DownloadMenuCategoriesResponse: Decodable {
    public var categories: [FoodTypeDTO]

    // MOCK: - remove
    public init(categories: [FoodTypeDTO]) {
        self.categories = categories
    }
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
