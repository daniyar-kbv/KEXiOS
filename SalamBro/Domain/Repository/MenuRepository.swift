//
//  MenuRepository.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

protocol MenuRepository {
    func getMenuCategories() -> [FoodType]
    func getMenuItems()  -> [Food]
    func getMenuAds() -> [Ad]
}
