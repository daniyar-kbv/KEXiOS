//
//  MenuViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

class MenuViewModel {
    
    private let menuRepository: MenuRepository
    
    var ads: [Ad]
    var categories: [FoodType]
    var items: [Food]

    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
        self.ads = menuRepository.getMenuAds()
        self.categories = menuRepository.getMenuCategories()
        self.items = menuRepository.getMenuItems()
    }
    
    
}
