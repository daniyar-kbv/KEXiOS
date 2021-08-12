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
    func openPromotion(by id: Int)
}

final class MenuRepositoryImpl: MenuRepository {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let menuService: MenuService
    private let storage: DefaultStorage

    init(menuService: MenuService,
         storage: DefaultStorage)
    {
        self.menuService = menuService
        self.storage = storage

        bindNotifications()
    }

    func getMenuItems() {
        guard let leadUUID = storage.leadUUID else { return }

        let promotionsSequence = menuService.getPromotions(leadUUID: leadUUID)
        let productsSequence = menuService.getProducts(for: leadUUID)

        let finalSequence = Single.zip(promotionsSequence,
                                       productsSequence,
                                       resultSelector: {
                                           promotions, productsData ->
                                               ([Promotion],
                                                [MenuCategory]) in
                                           (
                                               promotions,
                                               productsData
                                           )
                                       })
        outputs.didStartRequest.accept(())
        finalSequence.subscribe(onSuccess: {
            [weak self] promotions, categories in
            self?.outputs.didGetPromotions.accept(promotions)
            self?.outputs.didGetCategories.accept(categories)
            self?.outputs.didEndRequest.accept(())
        }, onError: { [weak self] error in
            self?.outputs.didEndRequest.accept(())
            self?.outputs.didGetError.accept(error as? ErrorPresentable)
        }).disposed(by: disposeBag)
    }

    func openPromotion(by id: Int) {
        guard let leadUUID = storage.leadUUID else { return }

        outputs.didStartRequest.accept(())
        menuService.getPromotionDetail(for: leadUUID, by: id)
            .subscribe { [weak self] promotion in
                self?.process(promotion: promotion)
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }
            .disposed(by: disposeBag)
    }
}

extension MenuRepositoryImpl {
    private func bindNotifications() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.updateMenu.name)
            .subscribe(onNext: { [weak self] _ in
                self?.getMenuItems()
            })
            .disposed(by: disposeBag)
    }

    private func process(promotion: Promotion) {
        guard let url = URL(string: promotion.link ?? "") else { return }
        outputs.openPromotion.accept((url, promotion.name))
    }
}

extension MenuRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let didGetPromotions = PublishRelay<[Promotion]>()
        let didGetCategories = PublishRelay<[MenuCategory]>()
        let didGetPositions = PublishRelay<[MenuPosition]>()
        let openPromotion = PublishRelay<(url: URL, name: String)>()
    }
}
