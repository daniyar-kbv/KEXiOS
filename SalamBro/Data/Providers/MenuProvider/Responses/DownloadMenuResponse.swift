//
//  DownloadBrandListResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public class DownloadMenuCategoriesResponse: Decodable {
    public var categories: [FoodType]
    
    // MOCK: - remove
    public init(categories: [FoodType]) {
        self.categories = categories
    }
}

// MOCK: - remove
extension DownloadMenuCategoriesResponse {
    public static var mockResponse: DownloadMenuCategoriesResponse {
        .init(categories: getMenuCategories())
    }
    
    private static func getMenuCategories() -> [FoodType] {
        var temp: [FoodType] = []
        let titles = ["combos", "sushi", "burgers", "doners", "template", "template", "template", "template", "template"]
        for i in 0..<9 {
            temp.append( FoodType(title: titles[i], position: i, foods: []))
        }
        return temp
    }
}
