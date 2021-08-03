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
    func cleanUp()

    func getTotalAmount() -> Double
}

final class CartRepositoryImpl: CartRepository {
    private var cartStorage: CartStorage
    private let ordersService: OrdersService
    private let defaultStorage: DefaultStorage

    private let disposeBag = DisposeBag()

    let outputs = Output()

    init(cartStorage: CartStorage,
         ordersService: OrdersService,
         defaultStorage: DefaultStorage)
    {
        self.cartStorage = cartStorage
        self.ordersService = ordersService
        self.defaultStorage = defaultStorage
    }
}

extension CartRepositoryImpl {
    func getItems() -> [CartItem] {
        return cartStorage.cart.items
    }

    func addItem(item: CartItem) {
        if cartStorage.cart.items.contains(item),
           let index = cartStorage.cart.items.firstIndex(of: item)
        {
            cartStorage.cart.items[index].count += 1
        } else {
            cartStorage.cart.items.append(item)
        }
        updateCart()
    }

    func removeItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        cartStorage.cart.items.remove(at: index)
        updateCart()
    }

    func incrementItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        cartStorage.cart.items[index].count += 1
        updateCart()
    }

    func decrementItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        cartStorage.cart.items[index].count -= 1
        guard cartStorage.cart.items[index].count != 0 else {
            removeItem(positionUUID: positionUUID)
            return
        }
        updateCart()
    }

    func cleanUp() {
        cartStorage.cart.items = []
        updateCart()
    }

    func getTotalAmount() -> Double {
        return cartStorage.cart.getTotalPrice()
    }
}

extension CartRepositoryImpl {
    private func getIndex(of positionUUID: String) -> Int? {
        return cartStorage.cart.items.firstIndex(where: { $0.position.uuid == positionUUID })
    }

    private func updateCart() {
        outputs.didChange.accept(cartStorage.cart.items)
        guard let leadUUID = defaultStorage.leadUUID else { return }
        let dto = cartStorage.cart.toDTO()
        outputs.didStartRequest.accept(())
        ordersService.updateCart(for: leadUUID, dto: dto)
            .subscribe(onSuccess: { [weak self] cart in
                self?.outputs.didEndRequest.accept(())
                self?.cartStorage.cart = cart
                self?.outputs.didChange.accept(cart.items)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

extension CartRepositoryImpl {
    struct Output {
        let didChange = PublishRelay<[CartItem]>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
    }
}
