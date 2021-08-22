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
    func getItems(withLoader: Bool)
    func addItem(item: CartItem, isAdditional: Bool)
    func removeItem(internalUUID: String)
    func incrementItem(internalUUID: String)
    func decrementItem(internalUUID: String)
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

    private var additionalPositions: [AdditionalPosition] = []
    private lazy var cart: Cart = cartStorage.cart {
        didSet {
            cartStorage.cart = cart
        }
    }

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

    func addItem(item: CartItem, isAdditional: Bool) {
        if cartStorage.cart.items.contains(item),
           let index = cartStorage.cart.items.firstIndex(of: item)
        {
            cart.items[index].count += 1
        } else {
            cart.items.append(item)
        }

        if isAdditional {
            sendNewCart(withDebounce: true)
        } else {
            sendNewCart(withDebounce: false)
        }
    }

    func removeItem(internalUUID: String) {
        guard let index = getIndex(of: internalUUID) else { return }
        cart.items.remove(at: index)
        sendNewCart(withDebounce: false)
    }

    func incrementItem(internalUUID: String) {
        guard let index = getIndex(of: internalUUID) else { return }
        cart.items[index].count += 1
        sendNewCart(withDebounce: true)
    }

    func decrementItem(internalUUID: String) {
        guard let index = getIndex(of: internalUUID) else { return }
        cart.items[index].count -= 1
        if cart.items[index].count == 0,
           let index = getIndex(of: internalUUID)
        {
            cart.items.remove(at: index)
        }
        sendNewCart(withDebounce: true)
    }

    func cleanUp() {
        cart.items = []
        cart.positionsCount = 0
        getItems(withLoader: true)
    }

    func update() {
        evokeUpdateCart.accept(())
    }

    func getIsEmpty() -> Bool {
        return cart.items.isEmpty
    }

    func getTotalAmount() -> Double {
        return cart.price
    }

    func getLocalCart() -> Cart {
        return cart
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
}

extension CartRepositoryImpl {
    private func sendNewCart(withDebounce: Bool) {
        getItems(withLoader: false)
        withDebounce ?
            evokeDebouncedUpdateCart.accept(()) :
            evokeUpdateCart.accept(())
    }

    func getItems(withLoader: Bool) {
        var additionalItems: [CartItem] = []

        if withLoader {
            outputs.didStartRequest.accept(())
        }

        guard let leadUUID = defaultStorage.leadUUID else { return }
        ordersService.getAdditionalProducts(for: leadUUID)
            .subscribe(onSuccess: { [weak self] positions in
                self?.additionalPositions = positions
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)

        additionalPositions.forEach { additionalItems.append($0.toCartItem(count: $0.count, comment: "", modifiers: [], additional: true)) }

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
            .debounce(.milliseconds(700), scheduler: MainScheduler.instance)
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

    private func getIndex(of internalUUID: String) -> Int? {
        return cart.items.firstIndex(where: { $0.internalUUID == internalUUID })
    }

    private func updateCart(withLoader: Bool = true) {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        let dto = cart.toDTO()

        if withLoader {
            outputs.didStartRequest.accept(())
        }

        ordersService.updateCart(for: leadUUID, dto: dto)
            .subscribe(onSuccess: { [weak self] cart in
                self?.process(cart: cart)
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.process(error: error)
                self?.outputs.didEndRequest.accept(())
            })
            .disposed(by: disposeBag)
    }

    private func process(cart: Cart) {
        self.cart = cart
        getItems(withLoader: true)
    }

    private func process(error: Error) {
        cart = cartStorage.cart
        getItems(withLoader: true)
        guard let error = error as? ErrorPresentable else { return }
        outputs.didGetError.accept(error)
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
