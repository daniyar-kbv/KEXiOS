//
//  DownloadBrandsResponse.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

public struct DownloadBrandsResponse: Decodable {
    public var brands: [BrandDTO]
    public var ratios: [RatioDTO]
}

// MOCK: - remove
extension DownloadBrandsResponse {
    public static var mockResponse: DownloadBrandsResponse {
        .init(brands: getFigmaBrands(),
              ratios: getRatios())
    }

    private static func getFigmaBrands() -> [BrandDTO] {
        var brands: [BrandDTO] = []
        let brand0 = BrandDTO(id: 0, name: "SalamBro", priority: 4)
        let brand1 = BrandDTO(id: 1, name: "Marmelad", priority: 3)
        let brand2 = BrandDTO(id: 2, name: "Zhekas", priority: 2)
        let brand3 = BrandDTO(id: 3, name: "Chicken", priority: 4)
        let brand4 = BrandDTO(id: 4, name: "HalalBite", priority: 4)
        let brand5 = BrandDTO(id: 5, name: "HalalSlice", priority: 1)
        let brand6 = BrandDTO(id: 6, name: "QazaqGuys", priority: 3)
        let brand7 = BrandDTO(id: 7, name: "Sushi", priority: 4)
        let arrayOfBrands = [brand0, brand1, brand2, brand3, brand4, brand5, brand6, brand7, brand0, brand1, brand2, brand3, brand4, brand5, brand6, brand7]
        brands.append(contentsOf: arrayOfBrands)
        return brands
    }

    private static func getRatios() -> [RatioDTO] {
        let brands = getFigmaBrands()
        var ratios: [RatioDTO] = []
        for i in brands {
            ratios.append(getRatio(priority: i.priority))
        }
        return ratios
    }

    private static func getRatio(priority: Int) -> RatioDTO {
        switch priority {
        case 1:
            return RatioDTO(x: 1.0, y: 0.42)
        case 2:
            return RatioDTO(x: 0.58, y: 0.88)
        case 3:
            return RatioDTO(x: 0.58, y: 0.42)
        case 4:
            return RatioDTO(x: 0.42, y: 0.42)
        default:
            return RatioDTO(x: 0, y: 0)
        }
    }
}
