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
    private let positionUUID: String
    private let defaultStorage: DefaultStorage
    private let ordersService: OrdersService
    private let cartRepository: CartRepository

    private let disposeBag = DisposeBag()
    private var position: MenuPositionDetail? {
        didSet {
            outputs.itemImage.accept(URL(string: position?.image ?? ""))
            outputs.itemTitle.accept(position?.name)
            outputs.itemDescription.accept(position?.description)
//            Tech debt: change to prices logic
            outputs.itemPrice.accept("\(L10n.MenuDetail.proceedButton) \(position?.price.removeTrailingZeros() ?? "")")
//                self?.outputs.itemModifiers.accept(product.modifiers)
        }
    }

    private var comment: String?
    let outputs = Output()

    init(positionUUID: String,
         defaultStorage: DefaultStorage,
         ordersService: OrdersService,
         cartRepository: CartRepository)
    {
        self.positionUUID = positionUUID
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

        ordersService.getProductDetail(for: leadUUID, by: positionUUID)
            .subscribe(onSuccess: { [weak self] position in
                self?.outputs.didEndRequest.accept(())
                self?.position = position
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }).disposed(by: disposeBag)
    }

    func proceed() {
        guard let position = position else { return }

        let cartItem = CartItem(
            positionUUID: position.uuid,
            count: 1,
            comment: comment ?? "",
            position: .init(
                uuid: position.uuid,
                name: position.name,
                image: position.image,
                description: position.description,
                price: position.price,
                categoryUUID: position.categoryUUID
            ),
            modifiers: []
        )

        cartRepository.addItem(item: cartItem)
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
