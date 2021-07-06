//
//  OrdersRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/5/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol OrdersRepository: AnyObject {
    var outputs: OrdersRepositoryImpl.Output { get }

    func applyOrder(with dto: OrderApplyDTO)
    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data>
    func getProductDetail(for leadUUID: String, by positionUUID: String)
}

final class OrdersRepositoryImpl: OrdersRepository {
    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let ordersService: OrdersService

    init(ordersService: OrdersService) {
        self.ordersService = ordersService
    }

    func applyOrder(with dto: OrderApplyDTO) {
        outputs.didStartRequest.accept(())

        ordersService.applyOrder(dto: dto)
            .subscribe { [weak self] leadUUID in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetLeadUUID.accept(leadUUID)
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            }.disposed(by: disposeBag)
    }

    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data> {
        return ordersService.getProducts(for: leadUUID)
    }

    func getProductDetail(for leadUUID: String, by positionUUID: String) {
        ordersService.getProductDetail(for: leadUUID, by: positionUUID)
            .subscribe(onSuccess: { [weak self] position in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetProductDetail.accept(position)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            }).disposed(by: disposeBag)
    }
}

extension OrdersRepositoryImpl {
    struct Output {
        let didGetLeadUUID = PublishRelay<String>()
        let didGetProductDetail = PublishRelay<MenuPositionDetail>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
