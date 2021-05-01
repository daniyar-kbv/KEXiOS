//
//  CartRepositoryMock.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

class CartRepositoryMockImpl: CartRepository {
    
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
