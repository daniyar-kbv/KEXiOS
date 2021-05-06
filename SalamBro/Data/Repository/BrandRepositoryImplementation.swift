//
//  BrandRepositoryImpl.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation
import PromiseKit

public class BrandRepositoryImplementation: BrandRepository {
    private let provider: BrandProvider
    private let storage: BrandStorage

    public var brand: Brand? {
        get { storage.brand?.toDomain() }
        set { storage.brand = BrandDTO(from: newValue) }
    }

    public var brands: [Brand] { storage.brands?.map { $0.toDomain() } ?? [] }

    public init(provider: BrandProvider,
                storage: BrandStorage)
    {
        self.provider = provider
        self.storage = storage
    }

    public func downloadBrands() -> Promise<([Brand], [(Float, Float)])> {
        provider.downloadBrands().get {
            self.storage.brands = $0.brands
        }.map {
            ($0.brands.map { $0.toDomain() }, $0.ratios.map { ($0.x, $0.y) })
        }
    }
}
