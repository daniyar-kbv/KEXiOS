//
//  MenuRepositoryMockImpl.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

class MenuRepositoryMockImpl: MenuRepository {
    func getMenuCategories() -> [FoodType] {
        var temp: [FoodType] = []
        let titles = ["combos", "sushi", "burgers", "doners", "template", "template", "template", "template", "template"]
        for i in 0..<9 {
            temp.append( FoodType(title: titles[i], position: i, foods: []))
        }
        return temp
    }
    
    func getMenuItems() -> [Food] {
        var temp: [Food] = []
        for i in 0..<9 {
            temp.append(Food(id: i, title: "Бургер\(i)", price: 1490, description: "Двойной чизбургер (говяжий/куриный), картофель фри, напиток на выбор"))
        }
        return temp
    }
    
    func getMenuAds() -> [Ad] {
        var temp: [Ad] = []
        for i in 0..<9 {
            temp.append(Ad(name: "ad\(i)"))
        }
        return temp
    }
}
