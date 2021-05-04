//
//  DownloadMenuDetailItemResponse.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation

public struct DownloadMenuDetailItemReponse: Decodable {
    public var menuDetailItem: FoodDTO
}

extension DownloadMenuDetailItemReponse {
    public static var mockResponse: DownloadMenuDetailItemReponse {
        .init(menuDetailItem: getMenuDetailItem())
    }

    private static func getMenuDetailItem() -> FoodDTO {
        return FoodDTO(id: 0, title: "Чизбургер куриный", price: 1490, description: "Чизбургер куриный")
    }
}
