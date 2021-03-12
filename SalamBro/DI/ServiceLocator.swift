//
//  ServiceLocator.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation

final class ServiceLocator {
    
    private static var networkManager = NetworkManager()
    
    static func getBrandRepository() -> BrandRepository {
        return BrandRepositoryImpl(networkManager: networkManager)
    }

    private static func getNetworkManager() -> NetworkManager {
        return getNetworkManager()
    }
}
