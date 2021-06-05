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

protocol MenuViewModelProtocol: ViewModel {
    var coordinator: MenuCoordinator { get }
    var headerViewModels: [ViewModel?] { get }
    var cellViewModels: [[ViewModel]] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    var brandName: BehaviorRelay<String?> { get }
    func update()
    func selectMainInfo()
    func selectAddress()
}

final class MenuViewModel: MenuViewModelProtocol {
    public var coordinator: MenuCoordinator
    private let menuRepository: MenuRepository
    private let locationRepository: LocationRepository
    private let brandRepository: BrandRepository
    private let geoRepository: GeoRepository
    public var headerViewModels: [ViewModel?]
    public var cellViewModels: [[ViewModel]]
    public var updateTableView: BehaviorRelay<Void?>
    public var brandName: BehaviorRelay<String?>

    init(coordinator: MenuCoordinator,
         menuRepository: MenuRepository,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository,
         geoRepository: GeoRepository)
    {
        self.coordinator = coordinator
        cellViewModels = []
        headerViewModels = []
        updateTableView = .init(value: nil)
        self.menuRepository = menuRepository
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
        self.geoRepository = geoRepository
        brandName = .init(value: brandRepository.getCurrentBrand()?.name)
        download()
    }

    public func update() {
        download()
        brandName.accept(brandRepository.getCurrentBrand()?.name)
    }

    public func selectMainInfo() {
        coordinator.openSelectMainInfo { [unowned self] in
            self.update()
        }
    }

    public func selectAddress() {
        coordinator.openChangeAddress { [unowned self] _ in
            self.update()
        }
    }

    private func download() {
        startAnimation()
        cellViewModels = []
        headerViewModels = []
        updateTableView.accept(())
        firstly {
            self.menuRepository.downloadMenuAds()
        }.done {
            self.cellViewModels.append([
                AddressPickCellViewModel(address: self.geoRepository.currentAddress),
                AdCollectionCellViewModel(ads: $0.map { AdUI(from: $0) }),
            ])
        }.then {
            self.menuRepository.downloadMenuCategories()
        }.done {
            self.headerViewModels = [
                nil,
                CategoriesSectionHeaderViewModel(categories: $0.map { FoodTypeUI(from: $0) }),
            ]
            self.cellViewModels.append(
                $0.map { category in
                    category.foods.map { MenuCellViewModel(categoryPosition: category.position, food: FoodUI(from: $0)) }
                }.flatMap { $0 }
            )
//        }.then {
//            self.menuRepository.downloadMenuItems()
//        }.done {
//            self.cellViewModels.append($0.map { FoodUI(from: $0) }
//                .map { MenuCellViewModel(food: $0) })
        }.catch {
            self.coordinator.alert(error: $0)
        }.finally {
            self.updateTableView.accept(())
            self.stopAnimation()
        }
    }
}
