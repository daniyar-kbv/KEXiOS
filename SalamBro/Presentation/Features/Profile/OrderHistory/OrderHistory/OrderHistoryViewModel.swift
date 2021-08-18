//
//  OrderHistoryViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol OrderHistoryViewModel: AnyObject {
    var outputs: OrderHistoryViewModelImpl.Output { get }
    var orders: [OrdersList] { get }

    func update()
    func ordersEmpty() -> Bool
}

final class OrderHistoryViewModelImpl: OrderHistoryViewModel {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let ordersRepository: OrdersHistoryRepository

    private(set) var orders: [OrdersList] = []

    init(ordersRepository: OrdersHistoryRepository) {
        self.ordersRepository = ordersRepository
        bindOutputs()
    }

    func update() {
        ordersRepository.getOrders()
    }

    func ordersEmpty() -> Bool {
        return orders.isEmpty
    }

    private func bindOutputs() {
        ordersRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        ordersRepository.outputs.didGetOrders.bind {
            [weak self] orders in
            self?.orders = orders
            self?.outputs.didGetOrders.accept(())
        }
        .disposed(by: disposeBag)

        ordersRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        ordersRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)
    }
}

extension OrderHistoryViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()
        let didGetOrders = PublishRelay<Void>()
    }
}
