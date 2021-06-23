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
    func proceed()
    func set(comment: String)
}

final class MenuDetailViewModelImpl: MenuDetailViewModel {
    private let productUUID: String
    private let defaultStorage: DefaultStorage
    private let ordersService: OrdersService
    private let cartRepository: CartRepository

    private let disposeBag = DisposeBag()
    private var product: OrderProductDetailResponse.Data? {
        didSet {
            outputs.itemImage.accept(URL(string: product?.image ?? ""))
            outputs.itemTitle.accept(product?.name)
            outputs.itemDescription.accept(product?.description)
            outputs.itemPrice.accept("\(L10n.MenuDetail.proceedButton) \(product?.price.removeTrailingZeros() ?? "")")
//                self?.outputs.itemModifiers.accept(product.modifiers)
        }
    }

    private var comment: String?
    let outputs = Output()

    init(productUUID: String,
         defaultStorage: DefaultStorage,
         ordersService: OrdersService,
         cartRepository: CartRepository)
    {
        self.productUUID = productUUID
        self.defaultStorage = defaultStorage
        self.ordersService = ordersService
        self.cartRepository = cartRepository
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
                self?.product = product
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }).disposed(by: disposeBag)
    }

    func proceed() {
        guard let product = product else { return }
        let item = CartDTO.Item(
            positionUUID: product.uuid,
            count: 1,
            comment: comment ?? "",
            position: .init(name: product.name,
                            image: product.image ?? "",
                            description: product.description,
                            price: product.price,
                            category: product.branchCategory),
//            Tech debt: add modifiers
            modifiers: []
        )
        cartRepository.addItem(item: item)
    }

    func set(comment: String) {
        self.comment = comment
        outputs.comment.accept(comment)
    }
}

extension MenuDetailViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let close = PublishRelay<Void>()

        let comment = PublishRelay<String>()
        let itemImage = PublishRelay<URL?>()
        let itemTitle = PublishRelay<String?>()
        let itemDescription = PublishRelay<String?>()
        let itemPrice = PublishRelay<String?>()
//        let itemModifiers = PublishRelay<[OrderProductDetailResponse.Data.Modifier]>()
    }
}
