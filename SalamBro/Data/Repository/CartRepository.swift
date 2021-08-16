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

    func reload()
    func getItems()
    func addItem(item: CartItem)
    func removeItem(positionUUID: String)
    func incrementItem(positionUUID: String)
    func decrementItem(positionUUID: String)
    func cleanUp()
    func update()
    func getIsEmpty() -> Bool

    func getTotalAmount() -> Double
    func getLocalCart() -> Cart

    func applyPromocode(_ promocode: String)
}

final class CartRepositoryImpl: CartRepository {
    private var cartStorage: CartStorage
    private let ordersService: OrdersService
    private let defaultStorage: DefaultStorage

    private let disposeBag = DisposeBag()

    private let evokeDebouncedUpdateCart = PublishRelay<Void>()
    private let evokeUpdateCart = PublishRelay<Void>()

    private var additionalPositions: [MenuPosition] = []

    let outputs = Output()

    init(cartStorage: CartStorage,
         ordersService: OrdersService,
         defaultStorage: DefaultStorage)
    {
        self.cartStorage = cartStorage
        self.ordersService = ordersService
        self.defaultStorage = defaultStorage

        bindActions()
        bindNotifications()
    }
}

extension CartRepositoryImpl {
    func reload() {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        ordersService.getLeadInfo(for: leadUUID)
            .subscribe { [weak self] leadInfo in
                self?.process(cart: leadInfo.cart)
            } onError: { [weak self] error in
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            }
            .disposed(by: disposeBag)
    }

    func getItems() {
//        getAdditionalPositions() { [weak self] in
//            self?.sendItems()
//        }
        sendItems()
    }

    func addItem(item: CartItem) {
        if cartStorage.cart.items.contains(item),
           let index = cartStorage.cart.items.firstIndex(of: item)
        {
            cartStorage.cart.items[index].count += 1
        } else {
            cartStorage.cart.items.append(item)
        }
        sendNewCart(withDebounce: false)
    }

    func removeItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        cartStorage.cart.items.remove(at: index)
        sendNewCart(withDebounce: false)
    }

    func incrementItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        cartStorage.cart.items[index].count += 1
        sendNewCart(withDebounce: true)
    }

    func decrementItem(positionUUID: String) {
        guard let index = getIndex(of: positionUUID) else { return }
        cartStorage.cart.items[index].count -= 1
        if cartStorage.cart.items[index].count == 0,
           let index = getIndex(of: positionUUID)
        {
            cartStorage.cart.items.remove(at: index)
        }
        sendNewCart(withDebounce: true)
    }

    func cleanUp() {
        cartStorage.cart.items = []
        sendItems()
    }

    func update() {
        evokeUpdateCart.accept(())
    }

    func getIsEmpty() -> Bool {
        return cartStorage.cart.items.isEmpty
    }

    func getTotalAmount() -> Double {
        return cartStorage.cart.price
    }

    func getLocalCart() -> Cart {
        return cartStorage.cart
    }

    func applyPromocode(_ promocode: String) {
        outputs.didStartRequest.accept(())
        ordersService.applyPromocode(promocode: promocode)
            .subscribe(onSuccess: { [weak self] promocode in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.promocode.accept(promocode)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func getAdditionalPositions(completion: (() -> Void)? = nil) {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        outputs.didStartRequest.accept(())
        ordersService.getAdditionalProducts(for: leadUUID)
            .subscribe(onSuccess: { [weak self] positions in
                self?.outputs.didEndRequest.accept(())
                self?.additionalPositions = positions
                completion?()
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

extension CartRepositoryImpl {
    private func sendNewCart(withDebounce: Bool) {
        sendItems()
        withDebounce ?
            evokeDebouncedUpdateCart.accept(()) :
            evokeUpdateCart.accept(())
    }

    private func sendItems() {
//        Tech debt: change
//        let cartItems = cartStorage.cart
//            .filter {
//                !additionalPositions
//                    .map { $0.uuid }
//                    .contains($0.position.uuid)
//            }
        let additionalItems = cartStorage.cart.items
            .filter {
                additionalPositions
                    .map { $0.uuid }
                    .contains($0.position.uuid)
            }
        outputs.didChange.accept((cartStorage.cart, additionalItems))
    }

    private func bindActions() {
        evokeUpdateCart
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.updateCart(withLoader: true)
            })
            .disposed(by: disposeBag)

        evokeDebouncedUpdateCart
            .asObservable()
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.updateCart(withLoader: false)
            })
            .disposed(by: disposeBag)
    }

    private func bindNotifications() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.clearCart.name)
            .subscribe(onNext: { [weak self] _ in
                self?.cleanUp()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.cart.name)
            .subscribe(onNext: { [weak self] in
                guard let cart = $0.object as? Cart else { return }
                self?.process(cart: cart)
            })
            .disposed(by: disposeBag)
    }

    private func getIndex(of positionUUID: String) -> Int? {
        return cartStorage.cart.items.firstIndex(where: { $0.position.uuid == positionUUID })
    }

    private func updateCart(withLoader: Bool = true) {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        let dto = cartStorage.cart.toDTO()

        if withLoader {
            outputs.didStartRequest.accept(())
        }

        ordersService.updateCart(for: leadUUID, dto: dto)
            .subscribe(onSuccess: { [weak self] cart in
                self?.process(cart: cart)
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(cart: Cart) {
        cartStorage.cart = cart
        sendItems()
    }
}

extension CartRepositoryImpl {
    struct Output {
        let didChange = PublishRelay<(cart: Cart, additional: [CartItem])>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let promocode = PublishRelay<Promocode>()
    }
}
