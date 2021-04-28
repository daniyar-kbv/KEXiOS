//
//  APIService.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import UIKit

typealias ratio = (CGFloat, CGFloat)

class APIService :  NSObject {
    static let shared = APIService()
// for future use
//    private let sourcesURL = URL(string: "")!
//
//    func getCountries(completion : @escaping ([Country]) -> ()){
//        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
//            dump(data)
//            dump(urlResponse)
//            dump(error)
//            if let data = data {
//
//                let jsonDecoder = JSONDecoder()
//
//                let empData = try! jsonDecoder.decode([Country].self, from: data)
//                    completion(empData)
//            }
//        }.resume()
//    }
    
    func getCountries() -> [Country] {
        var temp: [Country] = []
        let ids = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]
        let names = ["Kazakhstan", "Russian Federation", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA","Kazakhstan", "Russian Federation", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA"]
        let callingCodes = ["+7", "+7", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1","+7", "+7", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1","+7", "+7", "+1", "+1", "+1", "+1", "+1", "+1", "+1", "+1"]
        for i in 0..<40 {
            temp.append(Country(id: ids[i], name: names[i], callingCode: callingCodes[i]))
        }
        temp[0].marked = true
        return temp
    }
    
    
    func getCountries() -> ([Brand], [ratio]) {
        var brands: [Brand] = []
        var ratios: [ratio] = []
        for i in 0..<40 {
            let priority = [1, 2, 3, 4].randomElement()! // 1 - long horizontal, 2 - long vertical, 3 - wide box, 4 - box
            let brand = Brand(id: i, name: ["SalamBro", "Marmelad", "Zhekas", "Chicken", "HalalBite", "HalalSlice", "QazaqGuys", "Sushi"].randomElement()!, priority: priority)
            
            brands.append(brand)
            if brands[i].priority == 1 {
                ratios.append((1.0, 0.42))
            } else if brands[i].priority == 2 {
                ratios.append((0.58, 0.885))
            } else if brands[i].priority == 3 {
                ratios.append((0.58, 0.42))
            } else if brands[i].priority == 4 {
                ratios.append((0.42, 0.42))
            } else {
                ratios.append((0, 0))
            }
        }
        for i in 0..<40 {
            print(brands[i])
            print(ratios[i])
        }
        print(brands)
        print(ratios)
        return (brands, ratios)
    }
    
    func getFigmaBrands() -> ([Brand], [ratio]) {
        var brands: [Brand] = []
        var ratios: [ratio] = []
//        for i in 0..<40 {
//            let priority = [1, 2, 3, 4].randomElement()! // 1 - long horizontal, 2 - long vertical, 3 - wide box, 4 - box
//            let brand = Brand(id: i, name: ["SalamBro", "Marmelad", "Zhekas"].randomElement()!, priority: priority)
//
//            brands.append(brand)
//            ratios.append(getRatio(priority: brands[i].priority))
//        }
//        (0.42, 0.42), (0.58, 0.42), (0.58, 0.88), (0.42, 0.42), (0.42, 0.42), (1.0, 0.42)
//        "SalamBro", "Marmelad", "Zhekas", "Chicken", "HalalBite", "HalalSlice", "QazaqGuys", "Sushi"
        let brand0 = Brand(id: 0, name: "SalamBro", priority: 4)
        let brand1 = Brand(id: 1, name: "Marmelad", priority: 3)
        let brand2 = Brand(id: 2, name: "Zhekas", priority: 2)
        let brand3 = Brand(id: 3, name: "Chicken", priority: 4)
        let brand4 = Brand(id: 4, name: "HalalBite", priority: 4)
        let brand5 = Brand(id: 5, name: "HalalSlice", priority: 1)
        let brand6 = Brand(id: 6, name: "QazaqGuys", priority: 3)
        let brand7 = Brand(id: 7, name: "Sushi", priority: 4)
        let arrayOfBrands = [brand0, brand1, brand2, brand3, brand4, brand5, brand6, brand7, brand0, brand1, brand2, brand3, brand4, brand5, brand6, brand7]
        brands.append(contentsOf: arrayOfBrands)
        
        for i in brands {
            ratios.append(getRatio(priority: i.priority))
        }
        return (brands, ratios)
    }

    func getRatio(priority: Int) -> ratio {
        switch priority {
        case 1:
            return (1.0, 0.42)
        case 2:
            return(0.58, 0.88)
        case 3:
            return (0.58, 0.42)
        case 4:
            return (0.42, 0.42)
        default:
            return (0, 0)
        }
    }
    
    func getCategories() -> [FoodType] {
        var temp: [FoodType] = []
        let titles = ["combos", "sushi", "burgers", "doners", "template", "template", "template", "template", "template"]
        for i in 0..<9 {
            temp.append( FoodType(title: titles[i], position: i, foods: []))
        }
        return temp
    }
}
