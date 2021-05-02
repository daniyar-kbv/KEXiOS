//
//  MenuRepository.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit

public protocol MenuRepository {
    func downloadMenuCategories() -> Promise<[FoodType]>
    func downloadMenuItems() -> Promise<[Food]>
    func downloadMenuAds() -> Promise<[Ad]>
}
