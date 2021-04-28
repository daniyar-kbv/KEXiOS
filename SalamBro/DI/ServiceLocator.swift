//
//  ServiceLocator.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation

final class ServiceLocator {
    
    private static var networkManager = APIService()
    
    static func getBrandRepository() -> BrandRepository {
        return BrandRepositoryImpl(networkManager: networkManager)
    }

    private static func getAPIService() -> APIService {
        return getAPIService()
    }
}
