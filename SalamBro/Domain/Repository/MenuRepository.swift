//
//  MenuRepository.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit

//  Tech debt: Legacy

public protocol MenuRepository {
    func downloadMenuCategories() -> Promise<[FoodType]>
    func downloadMenuItems() -> Promise<[Food]>
    func downloadMenuAds() -> Promise<[Ad]>
}
