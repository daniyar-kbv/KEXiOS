//
//  ServiceLocator.swift
//  SalamBro
//
//  Created by Murager on 11.03.2021.
//

import Foundation

final class ServiceLocator {
    
    static func getBrandRepository() -> BrandRepository {
        return BrandRepositoryImpl(networkManager: getNetworkManager())
        
        //return BrandRepositoryMockImpl()
    }
    
    

    private static func getNetworkManager() -> NetworkManager {
        return getNetworkManager()
    }
}
