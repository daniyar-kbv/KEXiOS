//
//  RepositoryComponents.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation

protocol RepositoryComponents: AnyObject {
    func makeLocationRepository() -> LocationRepository
    func makeBrandRepository() -> BrandRepository
    func makeCartRepository() -> CartRepository
}

final class RepositoryComponentsAssembly: DependencyFactory, RepositoryComponents {
    func makeLocationRepository() -> LocationRepository {
        return shared(LocationRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeBrandRepository() -> BrandRepository {
        return shared(BrandRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeCartRepository() -> CartRepository {
        return shared(CartRepositoryImpl(storage: makeLocalStorage()))
    }

    private func makeLocalStorage() -> Storage {
        return shared(.init())
    }
}
