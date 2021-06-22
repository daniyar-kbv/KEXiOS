//
//  MenuItemDetailViewModel.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

protocol MenuDetailViewModel: AnyObject {
    var outputs: MenuDetailViewModelImpl.Output { get }

    func update()
}

final class MenuDetailViewModelImpl: MenuDetailViewModel {
    private let productUUID: String
    private let defaultStorage: DefaultStorage
    private let ordersService: OrdersService

    private let disposeBag = DisposeBag()
    let outputs = Output()

    init(productUUID: String,
         defaultStorage: DefaultStorage,
         ordersService: OrdersService)
    {
        self.productUUID = productUUID
        self.defaultStorage = defaultStorage
        self.ordersService = ordersService
    }

    public func update() {
        download()
    }

    private func download() {
        guard let leadUUID = defaultStorage.leadUUID else { return }

        outputs.didStartRequest.accept(())

        ordersService.getProductDetail(for: leadUUID, by: productUUID)
            .subscribe(onSuccess: { [weak self] product in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.itemImage.accept(URL(string: product.image ?? ""))
                self?.outputs.itemTitle.accept(product.name)
                self?.outputs.itemDescription.accept(product.description)
                self?.outputs.itemPrice.accept(String(product.price.removeTrailingZeros()))
//                self?.outputs.itemModifiers.accept(product.modifiers)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }).disposed(by: disposeBag)
    }

//    MARK: test
}

extension MenuDetailViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let itemImage = PublishRelay<URL?>()
        let itemTitle = PublishRelay<String>()
        let itemDescription = PublishRelay<String>()
        let itemPrice = PublishRelay<String>()
//        let itemModifiers = PublishRelay<[OrderProductDetailResponse.Data.Modifier]>()
    }
}
