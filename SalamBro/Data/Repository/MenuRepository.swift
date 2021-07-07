//
//  MenuRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuRepository: AnyObject {
    var outputs: MenuRepositoryImpl.Output { get }

    func getMenuItems()
}

final class MenuRepositoryImpl: MenuRepository {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let ordersService: OrdersService
    private let promotionsService: PromotionsService
    private let storage: DefaultStorage

    init(ordersService: OrdersService, promotionsService: PromotionsService, storage: DefaultStorage) {
        self.ordersService = ordersService
        self.promotionsService = promotionsService
        self.storage = storage
    }

    func getMenuItems() {
        guard let leadUUID = storage.leadUUID else { return }

        let promotionsSequence = promotionsService.getPromotions()
        let productsSequence = ordersService.getProducts(for: leadUUID)

        let finalSequence = Single.zip(promotionsSequence,
                                       productsSequence,
                                       resultSelector: {
                                           promotions, productsData ->
                                               ([Promotion],
                                                [MenuCategory],
                                                [MenuPosition]) in
                                           (
                                               promotions,
                                               productsData.categories,
                                               productsData.positions
                                           )
                                       })
        finalSequence.subscribe(onSuccess: {
            [weak self] promotions, categories, positions in
            self?.outputs.didGetPromotions.accept(promotions)
            self?.outputs.didGetCategories.accept(categories)
            self?.outputs.didGetPositions.accept(positions)
            self?.outputs.didEndRequest.accept(())
        }, onError: { [weak self] error in
            self?.outputs.didEndRequest.accept(())
            self?.outputs.didGetError.accept(error as? ErrorPresentable)
        }).disposed(by: disposeBag)
    }
}

extension MenuRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didGetPromotions = PublishRelay<[Promotion]>()
        let didGetCategories = PublishRelay<[MenuCategory]>()
        let didGetPositions = PublishRelay<[MenuPosition]>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()
    }
}
