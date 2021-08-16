//
//  OrdersHistoryRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/12/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol OrdersHistoryRepository: AnyObject {
    var outputs: OrdersHistoryRepositoryImpl.Output { get }

    func getOrders()
}

final class OrdersHistoryRepositoryImpl: OrdersHistoryRepository {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let ordersHistoryService: OrdersHistoryService

    init(ordersHistoryService: OrdersHistoryService) {
        self.ordersHistoryService = ordersHistoryService
    }

    func getOrders() {
        outputs.didStartRequest.accept(())
        ordersHistoryService.getOrders()
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] ordersList in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetOrders.accept(ordersList)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                    return
                }
                self?.outputs.didFail.accept(NetworkError.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
}

extension OrdersHistoryRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()

        let didGetOrders = PublishRelay<[OrdersList]>()
    }
}
