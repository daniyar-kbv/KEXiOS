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
    private let ordersService: OrdersService
    private let storage: DefaultStorage

    private var isRequestingData = false
    private var receivedData = [ReceivedData]()

    init(menuService: MenuService,
         ordersService: OrdersService,
         storage: DefaultStorage)
    {
        self.menuService = menuService
        self.ordersService = ordersService
        self.storage = storage

        bindNotifications()
    }

    func getMenuItems() {
//        guard let leadUUID = storage.leadUUID else { return }
//
//        let leadInfoSequence = ordersService.getLeadInfo(for: leadUUID)
//        let promotionsSequence = menuService.getPromotions(leadUUID: leadUUID)
//        let productsSequence = menuService.getProducts(for: leadUUID)
//
//        let finalSequence = Single.zip(leadInfoSequence,
//                                       promotionsSequence,
//                                       productsSequence,
//                                       resultSelector: { ($0, $1, $2) })
//
//        outputs.didStartRequest.accept(())
//        finalSequence.subscribe(onSuccess: {
//            [weak self] leadInfo, promotions, categories in
//            self?.outputs.didStartDataProcessing.accept(())
//            self?.outputs.didGetAddressInfo.accept(leadInfo)
        ////            self?.outputs.didGetPromotions.accept(promotions)
//            self?.outputs.didGetCategories.accept(categories)
//            self?.outputs.didEndDataProcessing.accept(())
//            self?.outputs.didEndRequest.accept(())
//        }, onError: { [weak self] error in
//            self?.outputs.didEndRequest.accept(())
//            guard let error = error as? ErrorPresentable else { return }
//            self?.outputs.didGetError.accept(error)
//        }).disposed(by: disposeBag)

        receivedData.removeAll()
        outputs.didStartRequest.accept(())
        getLeadInfo()
        getPromotions()
        getCategories()
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
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
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

    private func getLeadInfo() {
        guard let leadUUID = storage.leadUUID else { return }

        ordersService.getLeadInfo(for: leadUUID)
            .subscribe(onSuccess: {
                [weak self] leadInfo in
                self?.receivedData.append(.init(data: leadInfo, type: .leadInfo))
                self?.check()
            }, onError: { [weak self] error in
                self?.process(error: error, type: .leadInfo)
            }).disposed(by: disposeBag)
    }

    private func getPromotions() {
        guard let leadUUID = storage.leadUUID else { return }

        menuService.getPromotions(leadUUID: leadUUID)
            .subscribe(onSuccess: {
                [weak self] promotions in
                self?.receivedData.append(.init(data: promotions, type: .promotions))
                self?.check()
            }, onError: { [weak self] error in
                self?.process(error: error, type: .promotions)
            }).disposed(by: disposeBag)
    }

    private func getCategories() {
        guard let leadUUID = storage.leadUUID else { return }

        menuService.getProducts(for: leadUUID)
            .subscribe(onSuccess: {
                [weak self] categories in
                self?.receivedData.append(.init(data: categories, type: .categories))
                self?.check()
            }, onError: { [weak self] error in
                self?.process(error: error, type: .categories)
            }).disposed(by: disposeBag)
    }

    private func process(error: Error, type: RequestType) {
        receivedData.append(.init(data: nil, type: type))
        check()
        guard let error = error as? ErrorPresentable else { return }
        outputs.didGetError.accept(error)
    }

    private func check() {
        guard receivedData.count == RequestType.allCases.count else { return }
        outputs.didStartDataProcessing.accept(())
        receivedData.forEach { receivedData in
            switch receivedData.type {
            case .leadInfo:
                guard let leadInfo = receivedData.data as? LeadInfo else { return }
                outputs.didGetAddressInfo.accept(leadInfo)
            case .promotions:
                guard let promotions = receivedData.data as? [Promotion] else { return }
                outputs.didGetPromotions.accept(promotions)
            case .categories:
                guard let categories = receivedData.data as? [MenuCategory] else { return }
                outputs.didGetCategories.accept(categories)
            }
        }
        outputs.didEndDataProcessing.accept(())
        outputs.didEndRequest.accept(())
    }
}

extension MenuRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let didStartDataProcessing = PublishRelay<Void>()
        let didGetAddressInfo = PublishRelay<LeadInfo>()
        let didGetPromotions = PublishRelay<[Promotion]>()
        let didGetCategories = PublishRelay<[MenuCategory]>()
        let didEndDataProcessing = PublishRelay<Void>()

        let openPromotion = PublishRelay<(url: URL, name: String)>()
    }

    private struct ReceivedData {
        let data: Any?
        let type: RequestType
    }

    private enum RequestType: CaseIterable {
        case leadInfo
        case promotions
        case categories
    }
}
