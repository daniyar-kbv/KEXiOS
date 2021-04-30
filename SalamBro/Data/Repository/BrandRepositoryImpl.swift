//
//  BrandRepositoryImpl.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation

class BrandRepositoryImpl: BrandRepository {

    private let api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    
    func getBrands() -> Array<String> {
        return Array<String>()
    }
}
