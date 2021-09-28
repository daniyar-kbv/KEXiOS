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

    func getPromotionsVerificationURL() -> String?
}

final class MenuRepositoryImpl: MenuRepository {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let menuService: MenuService
    private let ordersService: OrdersService
    private let storage: DefaultStorage

    private var menuData = MenuData()

    private var promotionsVerificationURL: String?

    init(menuService: MenuService,
         ordersService: OrdersService,
         storage: DefaultStorage)
    {
        self.menuService = menuService
        self.ordersService = ordersService
        self.storage = storage

        bindNotifications()
        bindMenuData()
    }

    func getMenuItems() {
        outputs.didStartRequest.accept(())
        menuData.cleanUp()
        getLeadInfo()
        getPromotions()
        getCategories()
    }

    func openPromotion(by id: Int) {
        guard let leadUUID = storage.leadUUID else { return }

        outputs.didStartRequest.accept(())

        menuService.getPromotions(leadUUID: leadUUID)
            .flatMap { [unowned self] promotionResult -> Single<Promotion> in
                promotionsVerificationURL = promotionResult.verificationURL
                return menuService.getPromotionDetail(for: leadUUID, by: id)
            }
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

    private func bindMenuData() {
        menuData.outputs.complete
            .subscribe(onNext: { [weak self] in
                self?.sendMenuData()
            })
            .disposed(by: disposeBag)
    }

    private func process(promotion: Promotion) {
        guard let url = URL(string: promotion.link ?? "") else { return }
        outputs.openPromotion.accept((promotion.id, url, promotion.name))
    }

    private func getLeadInfo() {
        guard let leadUUID = storage.leadUUID else { return }

        ordersService.getLeadInfo(for: leadUUID)
            .subscribe(onSuccess: {
                [weak self] leadInfo in
                self?.menuData.add(data: leadInfo, type: .leadInfo)
            }, onError: { [weak self] error in
                self?.process(error: error, type: .leadInfo)
            }).disposed(by: disposeBag)
    }

    private func getPromotions() {
        guard let leadUUID = storage.leadUUID else { return }

        menuService.getPromotions(leadUUID: leadUUID)
            .subscribe(onSuccess: {
                [weak self] promotionResult in
                self?.process(promotionResult: promotionResult)
            }, onError: { [weak self] error in
                self?.process(error: error, type: .promotions)
            }).disposed(by: disposeBag)
    }

    private func getCategories() {
        guard let leadUUID = storage.leadUUID else { return }

        menuService.getProducts(for: leadUUID)
            .subscribe(onSuccess: {
                [weak self] categories in
                self?.menuData.add(data: categories, type: .categories)
            }, onError: { [weak self] error in
                self?.process(error: error, type: .categories)
            }).disposed(by: disposeBag)
    }

    private func process(promotionResult: PromotionResult) {
        promotionsVerificationURL = promotionResult.verificationURL
        menuData.add(data: promotionResult.promotions, type: .promotions)
    }

    private func process(error: Error, type: RequestType) {
        menuData.add(type: type)
        guard let error = error as? ErrorPresentable else { return }
        outputs.didGetError.accept(error)
    }

    private func sendMenuData() {
        var dataToSend = (menuData.leadInfo.data, menuData.promotions.data, menuData.categories.data)
        if let data = menuData.categories.data, data.isEmpty {
            dataToSend.1?.removeAll()
            outputs.didGetBranchClosed.accept(())
        }
        outputs.didGetData.accept(dataToSend)
        outputs.didEndRequest.accept(())
    }
}

extension MenuRepositoryImpl {
    func getPromotionsVerificationURL() -> String? {
        return promotionsVerificationURL
    }
}

extension MenuRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
        let didGetBranchClosed = PublishRelay<Void>()

        let didGetData = PublishRelay<(leadInfo: LeadInfo?,
                                       promotions: [Promotion]?,
                                       categories: [MenuCategory]?)>()

        let openPromotion = PublishRelay<(id: Int, url: URL, name: String)>()

        let participationVerified = PublishRelay<Void>()
    }

    enum RequestType: CaseIterable {
        case leadInfo
        case promotions
        case categories
    }

    class MenuData {
        var leadInfo = Data<LeadInfo>()
        var promotions = Data<[Promotion]>()
        var categories = Data<[MenuCategory]>()

        let outputs = Output()

        func add<T: Decodable>(data: T?, type: RequestType) {
            switch type {
            case .leadInfo: leadInfo.assign(data: data as? LeadInfo)
            case .promotions: promotions.assign(data: data as? [Promotion])
            case .categories: categories.assign(data: data as? [MenuCategory])
            }
            check()
        }

        func add(type: RequestType) {
            switch type {
            case .leadInfo: leadInfo.assign(data: nil)
            case .promotions: promotions.assign(data: nil)
            case .categories: categories.assign(data: nil)
            }
            check()
        }

        func cleanUp() {
            leadInfo = .init()
            promotions = .init()
            categories = .init()
        }

        private func isComplete() -> Bool {
            return leadInfo.isReceived && promotions.isReceived && categories.isReceived
        }

        private func check() {
            guard isComplete() else { return }
            outputs.complete.accept(())
        }

        class Data<T: Decodable> {
            var data: T? = nil
            var isReceived = false

            func assign(data: T?) {
                self.data = data
                isReceived = true
            }
        }

        struct Output {
            let complete = PublishRelay<Void>()
        }
    }
}
