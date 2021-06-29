//
//  CartRepositoryMock.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartRepository {
    var outputs: CartRepositoryImpl.Output { get }

    func getItems() -> [CartItem]
    func addItem(item: CartItem)
    func removeItem(positionUUID: String)
    func incrementItem(positionUUID: String)
    func decrementItem(positionUUID: String)
}

final class CartRepositoryImpl: CartRepository {
    private var storage: CartStorage

    let outputs = Output()

    init(storage: CartStorage) {
        self.storage = storage
    }
}

extension CartRepositoryImpl {
    func getItems() -> [CartItem] {
        return storage.cartItems
    }

    func addItem(item: CartItem) {
        if storage.cartItems.contains(item),
           let index = storage.cartItems.firstIndex(of: item)
        {
            storage.cartItems[index].count += 1
        } else {
            storage.cartItems.append(item)
        }
        outputs.didChange.accept(storage.cartItems)
    }

    func removeItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        storage.cartItems.remove(at: index)
        outputs.didChange.accept(storage.cartItems)
    }

    func incrementItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        storage.cartItems[index].count += 1
        outputs.didChange.accept(storage.cartItems)
    }

    func decrementItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        storage.cartItems[index].count -= 1
        if storage.cartItems[index].count == 0 {
            removeItem(positionUUID: positionUUID)
        }
        outputs.didChange.accept(storage.cartItems)
    }

    private func getIndex(of positionUUID: String) -> Int? {
        return storage.cartItems.firstIndex(where: { $0.positionUUID == positionUUID })
    }
}

extension CartRepositoryImpl {
    struct Output {
        let didChange = PublishRelay<[CartItem]>()
    }
}
