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
    func loadMoreDataIfNeeded(for index: Int)
    func getContact() -> Contact?
}

final class OrderHistoryViewModelImpl: OrderHistoryViewModel {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let ordersRepository: OrdersHistoryRepository

    private let storage: DocumentsStorage

    private var currentPage: Int?
    private var pageLimit: Int?

    private(set) var orders: [OrdersList] = []

    init(ordersRepository: OrdersHistoryRepository, storage: DocumentsStorage) {
        self.ordersRepository = ordersRepository
        self.storage = storage
        bindOutputs()
    }

    func update() {
        ordersRepository.getOrders(page: 1)
    }

    func ordersEmpty() -> Bool {
        return orders.isEmpty
    }

    func getContact() -> Contact? {
        return storage.contacts.first(where: { $0.getType() == .callCenter })
    }

    func loadMoreDataIfNeeded(for index: Int) {
        guard var currentPage = currentPage, let pageLimit = pageLimit else { return }
        if index == orders.count - 1 {
            if currentPage < pageLimit {
                currentPage = currentPage + 1
                ordersRepository.getOrders(page: currentPage)
            }
        }
    }

    private func bindOutputs() {
        ordersRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        ordersRepository.outputs.didGetOrders.bind {
            [weak self] response in
            self?.currentPage = response?.page
            self?.pageLimit = response?.total
            response?.page == 1 ?
                self?.orders = response?.results ?? [] :
                self?.orders.append(contentsOf: response?.results ?? [])
            self?.outputs.didGetOrders.accept(())
        }
        .disposed(by: disposeBag)

        ordersRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        ordersRepository.outputs.didFail
            .subscribe(onNext: { [weak self] error in
                if (error as? NetworkError) == .unauthorized {
                    self?.outputs.didGetAuthError.accept(error)
                    return
                }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

extension OrderHistoryViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
        let didGetAuthError = PublishRelay<ErrorPresentable>()
        let didGetOrders = PublishRelay<Void>()
    }
}
