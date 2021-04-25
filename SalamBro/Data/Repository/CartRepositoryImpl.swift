//
//  CartRepositoryImplementation.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

class CartRepositoryIml: BrandRepository {

    
    private let api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    
    func getBrands() -> Array<String> {
        return Array<String>()
    }
}
