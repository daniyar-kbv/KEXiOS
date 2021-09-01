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

    func update(page: Int)
    func ordersEmpty() -> Bool
    func getCurrentPageIndex() -> Int
    func getTotalPageCount() -> Int
    func loadMoreData()
}

final class OrderHistoryViewModelImpl: OrderHistoryViewModel {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let ordersRepository: OrdersHistoryRepository

    private var currentPage: Int?
    private var pageLimit: Int?

    private(set) var orders: [OrdersList] = []

    init(ordersRepository: OrdersHistoryRepository) {
        self.ordersRepository = ordersRepository
        bindOutputs()
    }

    func update(page: Int) {
        orders.removeAll()
        ordersRepository.getOrders(page: page)
    }

    func ordersEmpty() -> Bool {
        return orders.isEmpty
    }

    func getCurrentPageIndex() -> Int {
        return currentPage ?? 0
    }

    func getTotalPageCount() -> Int {
        return pageLimit ?? 0
    }

    func loadMoreData() {
        guard var nextPage = currentPage else { return }
        nextPage = nextPage + 1

        ordersRepository.getOrders(page: nextPage)
    }

    private func bindOutputs() {
        ordersRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        ordersRepository.outputs.didGetOrders.bind {
            [weak self] response in
            self?.currentPage = response?.page
            self?.pageLimit = response?.total
            self?.orders.append(contentsOf: response?.results ?? [])
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
