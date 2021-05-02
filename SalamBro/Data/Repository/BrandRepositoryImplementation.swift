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
    public init(provider: BrandProvider) {
        self.provider = provider
    }

    public func downloadBrands() -> Promise<([Brand], [(Float, Float)])> {
        provider.downloadBrands().map {
            ($0.brands.map { $0.toDomain() }, $0.ratios.map { ($0.x, $0.y) })
        }
    }
}
