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

    func increment(postitonUUID: String)
    func decrement(postitonUUID: String)
    func delete(postitonUUID: String)
}

final class CartViewModelImpl: CartViewModel {
    private let disposeBag = DisposeBag()
    private let cartRepository: CartRepository

    var items: [CartItem] = []
    let outputs = Output()

    init(cartRepository: CartRepository) {
        self.cartRepository = cartRepository

        bind()
    }

    private func bind() {
        cartRepository.outputs.didChange
            .subscribe(onNext: { [weak self] items in
                self?.items = items
                self?.outputs.update.accept(())
            }).disposed(by: disposeBag)
    }

    func getCart() {
        items = cartRepository.getItems()
        outputs.update.accept(())
    }

    func getTotalCount() -> Int {
        return items.count
    }

    func getTotalPrice() -> String {
        return items.map { $0.position.price * Double($0.count) }.reduce(0, +).removeTrailingZeros()
    }

    func increment(postitonUUID: String) {
        cartRepository.incrementItem(positionUUID: postitonUUID)
        outputs.update.accept(())
    }

    func decrement(postitonUUID: String) {
        cartRepository.decrementItem(positionUUID: postitonUUID)
        outputs.update.accept(())
    }

    func delete(postitonUUID: String) {
        cartRepository.removeItem(positionUUID: postitonUUID)
        outputs.update.accept(())
    }
}

extension CartViewModelImpl {
    struct Output {
        let update = PublishRelay<Void>()
    }
}
