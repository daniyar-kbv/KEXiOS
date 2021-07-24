//
//  MenuDetailRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuDetailRepository: AnyObject {
    var outputs: MenuDetailRepositoryImpl.Output { get }

    func getProductDetail(for leadUUID: String, by positionUUID: String)
    func setSelectedModifiers(with modifiers: [Modifier])
}

final class MenuDetailRepositoryImpl: MenuDetailRepository {
    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let ordersService: OrdersService

    init(ordersService: OrdersService) {
        self.ordersService = ordersService
    }

    func getProductDetail(for leadUUID: String, by positionUUID: String) {
        outputs.didStartRequest.accept(())
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

    func setSelectedModifiers(with modifiers: [Modifier]) {
        outputs.updateSelectedModifiers.accept(modifiers)
    }
}

extension MenuDetailRepositoryImpl {
    struct Output {
        let didGetProductDetail = PublishRelay<MenuPositionDetail>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let updateSelectedModifiers = PublishRelay<[Modifier]>()
    }
}
