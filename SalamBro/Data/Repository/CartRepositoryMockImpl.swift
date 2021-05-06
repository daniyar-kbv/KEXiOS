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
        for i in 0 ..< 6 {
            temp.append(CartProduct(id: i, name: "Чизбургер куриный", description: [nil, "Coca-Cola 0.5, Pepsi 0.5"].randomElement()!, price: [300, 1500].randomElement()!, count: Int.random(in: 1 ... 4), commentary: ["Два двойных чизбургера (говяжий/куриный) на выбор, два картофеля фри, два напитка напиток на выбор", nil].randomElement()!, available: Bool.random()))
        }
        temp.append(CartProduct(id: 7, name: "Чисто Алмаатинское супер комбо для двоих, плюс в подарок две пиццы и большая картошка фри", description: "Coca-Cola 0.5, Pepsi 0.5", price: [300, 1500].randomElement()!, count: Int.random(in: 1 ... 4), commentary: [nil].randomElement()!, available: true))
        return temp
    }

    func getCartAdditionalProducts() -> [CartAdditionalProduct] {
        var temp: [CartAdditionalProduct] = []
        for i in 0 ..< 4 {
            temp.append(CartAdditionalProduct(id: i, name: "Кетчуп", price: 100, count: Int.random(in: 0 ... 3), available: Bool.random()))
        }
        temp.append(CartAdditionalProduct(id: 4, name: "Кетчуп", price: 100, count: Int.random(in: 0 ... 3), available: Bool.random()))
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
