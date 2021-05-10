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

public protocol MenuViewModelProtocol: ViewModel {
    var headerViewModels: [ViewModel?] { get }
    var cellViewModels: [[ViewModel]] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    var isAnimating: BehaviorRelay<Bool> { get }
    var brandName: BehaviorRelay<String?> { get }
    func update()
    func selectMainInfo()
    func selectAddress()
}

public final class MenuViewModel: MenuViewModelProtocol {
    public var router: Router
    private let menuRepository: MenuRepository
    private let brandRepository: BrandRepository
    private let geoRepository: GeoRepository
    public var headerViewModels: [ViewModel?]
    public var cellViewModels: [[ViewModel]]
    public var updateTableView: BehaviorRelay<Void?>
    public var isAnimating: BehaviorRelay<Bool>
    public var brandName: BehaviorRelay<String?>

    init(router: Router,
         menuRepository: MenuRepository,
         brandRepository: BrandRepository,
         geoRepository: GeoRepository)
    {
        self.router = router
        cellViewModels = []
        headerViewModels = []
        updateTableView = .init(value: nil)
        isAnimating = .init(value: false)
        self.menuRepository = menuRepository
        self.brandRepository = brandRepository
        self.geoRepository = geoRepository
        brandName = .init(value: brandRepository.brand?.name)
        download()
    }

    public func update() {
        download()
        brandName.accept(brandRepository.brand?.name)
    }

    public func selectMainInfo() {
        let context = MenuRouter.RouteType.selectMainInfo { [unowned self] in
            self.update()
        }
        router.enqueueRoute(with: context)
    }

    public func selectAddress() {
        let context = MenuRouter.RouteType.selectAddress { [unowned self] _ in
            self.update()
        }
        router.enqueueRoute(with: context)
    }

    private func download() {
        guard !isAnimating.value else { return }
        isAnimating.accept(true)

        cellViewModels = []
        headerViewModels = []
        updateTableView.accept(())
        firstly {
            self.menuRepository.downloadMenuCategories()
        }.done {
            self.headerViewModels = [
                nil,
                CategoriesSectionHeaderViewModel(router: self.router,
                                                 categories: $0.map { FoodTypeUI(from: $0) }),
            ]
        }.then {
            self.menuRepository.downloadMenuAds()
        }.done {
            self.cellViewModels.append([
                AddressPickCellViewModel(router: self.router,
                                         address: self.geoRepository.currentAddress),
                AdCollectionCellViewModel(router: self.router,
                                          ads: $0.map { AdUI(from: $0) }),
            ])
        }.then {
            self.menuRepository.downloadMenuItems()
        }.done {
            self.cellViewModels.append($0.map { FoodUI(from: $0) }
                .map { MenuCellViewModel(router: self.router,
                                         food: $0) })
        }.catch {
            self.router.alert(error: $0)
        }.finally {
            self.updateTableView.accept(())
            self.isAnimating.accept(false)
        }
    }
}
