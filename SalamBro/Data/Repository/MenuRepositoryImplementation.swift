//
//  MenuRepositoryMockImpl.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit

public final class MenuRepositoryImplementation: MenuRepository {
    private let provider: MenuProvider

    public init(provider: MenuProvider) {
        self.provider = provider
    }

    public func downloadMenuCategories() -> Promise<[FoodType]> {
        provider.downloadMenuCategories().map { $0.categories.map { $0.toDomain() } }
    }

    public func downloadMenuItems() -> Promise<[Food]> {
        provider.downloadMenuItems().map { $0.menuItems.map { $0.toDomain() } }
    }

    public func downloadMenuAds() -> Promise<[Ad]> {
        provider.downloadMenuAds().map { $0.menuAds.map { $0.toDomain() } }
    }
}
