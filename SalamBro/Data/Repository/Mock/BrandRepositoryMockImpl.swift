//
//  BrandRepositoryImpl.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation

class BrandRepositoryMockImpl: BrandRepository {
    
    func getBrands() -> Array<String> {
        return Array(arrayLiteral: "brand 1", "brand 2")
    }
    
}
