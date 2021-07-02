//
//  BrandRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol BrandRepository: AnyObject {
    func getCurrentBrand() -> Brand?
    func getBrands() -> [Brand]?
    func changeCurrent(brand: Brand)
    func set(brands: [Brand])
}

final class BrandRepositoryImpl: BrandRepository {
    private let storage: BrandStorage

    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let locationService: LocationService

    init(locationService: LocationService, storage: BrandStorage) {
        self.locationService = locationService
        self.storage = storage
    }

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
