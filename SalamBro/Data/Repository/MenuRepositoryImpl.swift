//
//  MenuRepositoryImpl.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

class MenuRepositoryimpl: MenuRepository {
    
    private let api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    
    func getMenuCategories() -> [FoodType] {
        return []
    }
    
    func getMenuItems() -> [Food] {
        return []
    }
    
    func getMenuAds() -> [Ad] {
        return []
    }
}
