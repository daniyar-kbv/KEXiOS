//
//  BrandRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

protocol BrandRepository: AnyObject {
    func getCurrentBrand() -> Brand?
    func getBrands() -> [Brand]?
    func changeCurrent(brand: Brand)
    func set(brands: [Brand])
}

final class BrandRepositoryImpl: BrandRepository {
    private let storage: BrandStorage

    init(storage: BrandStorage) {
        self.storage = storage
    }
}

extension BrandRepositoryImpl {
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
