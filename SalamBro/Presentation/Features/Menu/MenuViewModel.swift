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
    let outputs = Output()
    
    private let defaultStorage: DefaultStorage
    
    private let promotionsService: PromotionsService
    private let ordersService: OrdersService
    
    private let menuRepository: MenuRepository
    private let locationRepository: LocationRepository
    private let brandRepository: BrandRepository
    
    public var headerViewModels: [ViewModel?]
    public var cellViewModels: [[ViewModel]]
    public var brandName: BehaviorRelay<String?>

    init(defaultStorage: DefaultStorage,
         promotionsService: PromotionsService,
         ordersService: OrdersService,
         menuRepository: MenuRepository,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository) {
        self.defaultStorage = defaultStorage
        self.promotionsService = promotionsService
        self.ordersService = ordersService
        self.menuRepository = menuRepository
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
        
        cellViewModels = []
        headerViewModels = []
        brandName = .init(value: brandRepository.getCurrentBrand()?.name)
        download()
    }

    public func update() {
        download()
        brandName.accept(brandRepository.getCurrentBrand()?.name)
    }

    private func download() {
        guard let leadUuid = defaultStorage.leadUUID else { return }
        cellViewModels = []
        headerViewModels = []
        outputs.updateTableView.accept(())
        
        let promotionsSequence = promotionsService.getPromotions()
        let productsSequence = ordersService.getProducts(for: leadUuid)
        
        let finalSequesnce = Single.zip(promotionsSequence, productsSequence, resultSelector: { [weak self] (promotionsResponse, productsResponse) -> ([PromotionsResponse.ResponseData.Promotion]?, [OrderProductResponse.Category]?, [OrderProductResponse.Position]?) in
            return (
                promotionsResponse.data?.results,
                productsResponse.categories,
                productsResponse.positions
            )
        })
        
        finalSequesnce.subscribe(onSuccess: { [weak self] in
            self.cellViewModels.append([
                AddressPickCellViewModel(address: self?.locationRepository.getCurrentDeliveryAddress()?.address),
                AdCollectionCellViewModel(ads: $0.map { AdUI(from: $0) }),
            ])
        }, onError: { [weak self] error in
            self?.outputs.didGetError.accept(error as? ErrorPresentable)
        })
        
//        firstly {
//            self.menuRepository.downloadMenuAds()
//        }.done {
//            self.cellViewModels.append([
//                AddressPickCellViewModel(address: self.locationRepository.getCurrentDeliveryAddress()?.address),
//                AdCollectionCellViewModel(ads: $0.map { AdUI(from: $0) }),
//            ])
//        }.then {
//            self.menuRepository.downloadMenuCategories()
//        }.done {
//            self.headerViewModels = [
//                nil,
//                CategoriesSectionHeaderViewModel(categories: $0.map { FoodTypeUI(from: $0) }),
//            ]
//            self.cellViewModels.append(
//                $0.map { category in
//                    category.foods.map { MenuCellViewModel(categoryPosition: category.position, food: FoodUI(from: $0)) }
//                }.flatMap { $0 }
//            )
//        }.catch {
//            self.outputs.didGetError.accept($0 as? ErrorPresentable)
//        }.finally {
//            self.outputs.updateTableView.accept(())
//            self.stopAnimation()
//        }
    }
}

extension MenuViewModel {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let updateTableView = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()
    }
}
