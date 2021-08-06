//
//  CartViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartViewModel {
    var outputs: CartViewModelImpl.Output { get }
    var items: [CartItem] { get set }

    func getCart()
    func getTotalCount() -> Int
    func getTotalPrice() -> String
    func getIsEmpty() -> Bool

    func increment(postitonUUID: String)
    func decrement(postitonUUID: String)
    func delete(postitonUUID: String)

    func proceedButtonTapped()
}

final class CartViewModelImpl: CartViewModel {
    private let disposeBag = DisposeBag()
    private let cartRepository: CartRepository
    private let tokenStorage: AuthTokenStorage

    var items: [CartItem] = []
    let outputs = Output()

    init(cartRepository: CartRepository,
         tokenStorage: AuthTokenStorage)
    {
        self.cartRepository = cartRepository
        self.tokenStorage = tokenStorage

        bind()
    }
}

extension CartViewModelImpl {
    func getCart() {
        process(items: cartRepository.getItems())
    }

    func getTotalCount() -> Int {
        return items.count
    }

    func getTotalPrice() -> String {
        return items.map { ($0.position.price ?? 0) * Double($0.count) }.reduce(0, +).removeTrailingZeros()
    }

    func getIsEmpty() -> Bool {
        return items.isEmpty
    }

    func proceedButtonTapped() {
        guard tokenStorage.token != nil else {
            outputs.toAuth.accept(())
            return
        }

        outputs.toPayment.accept(())
    }
}

extension CartViewModelImpl {
    private func bind() {
        cartRepository.outputs.didChange
            .subscribe(onNext: { [weak self] items in
                self?.process(items: items)
            }).disposed(by: disposeBag)

        cartRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        cartRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        cartRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)
    }

    private func process(items: [CartItem]) {
        self.items = items
        outputs.update.accept(())
    }
}

extension CartViewModelImpl {
    func increment(postitonUUID: String) {
        cartRepository.incrementItem(positionUUID: postitonUUID)
    }

    func decrement(postitonUUID: String) {
        cartRepository.decrementItem(positionUUID: postitonUUID)
    }

    func delete(postitonUUID: String) {
        cartRepository.removeItem(positionUUID: postitonUUID)
    }
}

extension CartViewModelImpl {
    struct Output {
        let update = PublishRelay<Void>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let toAuth = PublishRelay<Void>()
        let toPayment = PublishRelay<Void>()
    }
}
