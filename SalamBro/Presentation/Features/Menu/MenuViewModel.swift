//
//  MenuViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift
import SVProgressHUD

protocol MenuViewModelProtocol {
    var outputs: MenuViewModel.Output { get }
    var headerViewModels: [ViewModel?] { get }
    var cellViewModels: [[ViewModel]] { get }
    var brandName: BehaviorRelay<String?> { get }

    func update()
}

final class MenuViewModel: MenuViewModelProtocol {
    private let disposeBag = DisposeBag()
    let outputs = Output()

    private let defaultStorage: DefaultStorage

    private let promotionsService: PromotionsService
    private let ordersService: OrdersService

    private let menuRepository: MenuRepository
    private let locationRepository: LocationRepository
    private let brandRepository: BrandRepository

    public var headerViewModels: [ViewModel?] = []
    public var cellViewModels: [[ViewModel]] = []

    public lazy var brandName = BehaviorRelay<String?>(value: brandRepository.getCurrentBrand()?.name)

    init(defaultStorage: DefaultStorage,
         promotionsService: PromotionsService,
         ordersService: OrdersService,
         menuRepository: MenuRepository,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository)
    {
        self.defaultStorage = defaultStorage
        self.promotionsService = promotionsService
        self.ordersService = ordersService
        self.menuRepository = menuRepository
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
    }

    public func update() {
        download()

        outputs.brandName.accept(brandRepository.getCurrentBrand()?.name)
    }

    private func download() {
        guard let leadUuid = defaultStorage.leadUUID else { return }

        cellViewModels = []
        headerViewModels = []

        outputs.didStartRequest.accept(())

        let promotionsSequence = promotionsService.getPromotions()
        let productsSequence = ordersService.getProducts(for: leadUuid)

        let finalSequesnce = Single.zip(promotionsSequence,
                                        productsSequence,
                                        resultSelector: {
                                            promotions, productsData ->
                                                ([PromotionsResponse.ResponseData.Promotion],
                                                 [OrderProductResponse.Data.Category],
                                                 [OrderProductResponse.Data.Position]) in
                                            (
                                                promotions,
                                                productsData.categories,
                                                productsData.positions
                                            )
                                        })

        finalSequesnce.subscribe(onSuccess: {
            [weak self] promotions, categories, positions in
            self?.outputs.didEndRequest.accept(())

            self?.setPromotions(promotions: promotions)
            self?.setCategories(categories: categories)
            self?.setPositions(positions: positions)

            self?.outputs.updateTableView.accept(())
        }, onError: { [weak self] error in
            self?.outputs.didEndRequest.accept(())
            self?.outputs.didGetError.accept(error as? ErrorPresentable)
        }).disposed(by: disposeBag)
    }

    private func setPromotions(promotions: [PromotionsResponse.ResponseData.Promotion]) {
        cellViewModels.append([
            AddressPickCellViewModel(address: locationRepository.getCurrentDeliveryAddress()?.address),
            AdCollectionCellViewModel(promotions: promotions),
        ])
    }

    private func setCategories(categories: [OrderProductResponse.Data.Category]) {
        headerViewModels = [
            nil,
            CategoriesSectionHeaderViewModel(categories: categories),
        ]
    }

    private func setPositions(positions: [OrderProductResponse.Data.Position]) {
        cellViewModels.append(positions.map { position in
            MenuCellViewModel(position: position)
        })
    }
}

extension MenuViewModel {
    struct Output {
        let brandName = PublishRelay<String?>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let updateTableView = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()
    }
}
