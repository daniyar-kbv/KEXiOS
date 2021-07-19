//
//  MenuViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import RxCocoa
import RxSwift
import SVProgressHUD

protocol MenuViewModelProtocol {
    var outputs: MenuViewModel.Output { get }
    var headerViewModels: [ViewModel?] { get }
    var cellViewModels: [[ViewModel]] { get }

    func update()
}

final class MenuViewModel: MenuViewModelProtocol {
    private let disposeBag = DisposeBag()
    let outputs = Output()

    private let locationRepository: AddressRepository
    private let brandRepository: BrandRepository
    private let menuRepository: MenuRepository
    private let defaultStorage: DefaultStorage

    public var headerViewModels: [ViewModel?] = []
    public var cellViewModels: [[ViewModel]] = []

    init(locationRepository: AddressRepository,
         brandRepository: BrandRepository,
         menuRepository: MenuRepository,
         defaultStorage: DefaultStorage)
    {
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
        self.menuRepository = menuRepository
        self.defaultStorage = defaultStorage

        bindMenuRepository()
        bindAddressRepository()
    }

    public func update() {
        download()

        outputs.brandImage.accept(brandRepository.getCurrentBrand()?.image)
        outputs.brandName.accept(brandRepository.getCurrentBrand()?.name)
    }

    private func bindMenuRepository() {
        menuRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        menuRepository.outputs.didEndRequest.bind {
            [weak self] _ in
            self?.outputs.didEndRequest.accept(())
            self?.outputs.updateTableView.accept(())
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        menuRepository.outputs.didGetPromotions.bind {
            [weak self] promotions in
            self?.setPromotions(promotions: promotions)
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.didGetCategories.bind {
            [weak self] categories in
            self?.setCategories(categories: categories)
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.didGetPositions.bind {
            [weak self] positions in
            self?.setPositions(positions: positions)
        }
        .disposed(by: disposeBag)

        menuRepository.outputs.needsLeadUUID
            .subscribe(onNext: { [weak self] in
                self?.locationRepository.applyOrder()
            }).disposed(by: disposeBag)
    }

    private func bindAddressRepository() {
        locationRepository.outputs.didGetLeadUUID
            .subscribe(onNext: { [weak self] leadUUID in
                self?.defaultStorage.persist(leadUUID: leadUUID)
                self?.update()
            }).disposed(by: disposeBag)
    }

    private func download() {
        cellViewModels = []
        headerViewModels = []

        menuRepository.getMenuItems()
    }

    private func setPromotions(promotions: [Promotion]) {
        let promotions = promotions.sorted(by: { $0.priority < $1.priority })
        var topViewModels = [ViewModel]()
        topViewModels.append(AddressPickCellViewModel(address: locationRepository.getCurrentDeliveryAddress()?.address))
        if promotions.count > 0 {
            topViewModels.append(AdCollectionCellViewModel(promotions: promotions))
        }
        cellViewModels.append(topViewModels)
    }

    private func setCategories(categories: [MenuCategory]) {
        headerViewModels = [
            nil,
            CategoriesSectionHeaderViewModel(categories: categories),
        ]
    }

    private func setPositions(positions: [MenuPosition]) {
        cellViewModels.append(positions.map { position in
            MenuCellViewModel(position: position)
        })
    }
}

extension MenuViewModel {
    struct Output {
        let brandImage = PublishRelay<String?>()
        let brandName = PublishRelay<String?>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let updateTableView = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()
    }
}
