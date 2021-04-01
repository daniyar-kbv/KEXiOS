//
//  APIService.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

class APIService :  NSObject {

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
    
    func getCartProducts() -> [CartProduct] {
        var temp: [CartProduct] = []
        for i in 0..<6 {
            temp.append(CartProduct(id: i, name: "Item \(i)", description: [nil, "Ingredient template"].randomElement()!, price: [300, 1500].randomElement()!, count: Int.random(in: 1...4), commentary: ["big comment to fit 1 line and blah blab bkah", nil].randomElement()!, available: Bool.random()))
        }
        temp.append(CartProduct(id: 7, name: "Item \(3) 23456721e9uh29ee893289012e20909i0a9s0u98u08j08j", description:  "049u54803utr034it-9i45t20u45tu-45ut-45ut-935-95-95u4t-935-935u-u45t-rut-9u43t-9ur-9-io5-to0t-04t-0iu45t-9u45t9-3tu9u-u", price: [300, 1500].randomElement()!, count: Int.random(in: 1...4), commentary: [nil].randomElement()!, available: true))
        return temp
    }
    
    func getCartAdditionalProducts() -> [CartAdditionalProduct] {
        var temp: [CartAdditionalProduct] = []
        for i in 0..<4 {
            temp.append(CartAdditionalProduct(id: i, name: "Additional Item \(i)", price: 100, count: Int.random(in: 0...3), available: Bool.random()))
        }
        temp.append(CartAdditionalProduct(id: 4, name: "sadjfijj0923ir023ir9023ie02e02i3e-i23-ier-2ifk2l40fr-32e0o13-ei9we-0", price: 100, count: Int.random(in: 0...3), available: Bool.random()))
        return temp
    }
    
    func getCart() -> Cart {
        let products = getCartProducts()
        let additional = getCartAdditionalProducts()
        
        var totalPrice: Int = 0
        var totalCount: Int = 0
        for i in products {
            if i.available {
                totalPrice += i.price * i.count
                totalCount += i.count
            }
        }
        
        for i in additional {
            if i.available {
                totalPrice += i.price * i.count
                totalCount += i.count
            }
        }
        let cart = Cart(id: 0, totalProducts: totalCount, totalPrice: totalPrice, products: products, productsAdditional: additional)
        return cart
    }
}
