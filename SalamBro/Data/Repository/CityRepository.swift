//
//  CitiesRrpository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/30/21.
//

import Foundation

protocol CityRepository: AnyObject {
    func getCurrentBrand() -> Brand?
    func getCities() -> [City]?
    func changeCurrent(brand: Brand)
    func set(brands: [Brand])
}

final class CityRepositoryImpl: CityRepository {
    private let storage: BrandStorage

    init(storage: BrandStorage) {
        self.storage = storage
    }
}

extension CityRepositoryImpl {
    func getCurrentBrand() -> Brand? {
        return storage.brand
    }

    func getBrands() -> [Brand]? {
        guard
            let brands = storage.brands,
            brands != []
        else {
            return nil
        }

        return brands
    }

    func changeCurrent(brand: Brand) {
        storage.brand = brand
    }

    func set(brands: [Brand]) {
        storage.brands = brands
    }
}
