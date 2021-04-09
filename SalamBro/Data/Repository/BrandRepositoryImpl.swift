//
//  BrandRepositoryImpl.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation

class BrandRepositoryImpl: BrandRepository {

    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getBrands() -> Array<String> {
        return Array<String>()
    }
}
