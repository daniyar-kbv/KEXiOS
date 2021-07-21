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
    var tableSections: [MenuViewModel.Section] { get }

    func update()
}

final class MenuViewModel: MenuViewModelProtocol {
    private let disposeBag = DisposeBag()
    let outputs = Output()

    private let locationRepository: AddressRepository
    private let brandRepository: BrandRepository
    private let menuRepository: MenuRepository
    private let defaultStorage: DefaultStorage

    public var tableSections: [Section] = []

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
        tableSections.removeAll()

        menuRepository.getMenuItems()
    }

    private func setPromotions(promotions: [Promotion]) {
        let promotions = promotions.sorted(by: { $0.priority < $1.priority })

        let addressViewModels = [AddressPickCellViewModel(address: locationRepository.getCurrentDeliveryAddress()?.address)]
        tableSections.append(.init(type: .address,
                                   headerViewModel: nil,
                                   cellViewModels: addressViewModels))

        if promotions.count > 0 {
            let promotionsViewModels = [AdCollectionCellViewModel(promotions: promotions)]
            tableSections.append(.init(type: .promotions,
                                       headerViewModel: nil,
                                       cellViewModels: promotionsViewModels))
        }
    }

    private func setCategories(categories: [MenuCategory]) {
        tableSections.append(.init(
            type: .positions,
            headerViewModel: CategoriesSectionHeaderViewModel(categories: categories),
            cellViewModels: []
        )
        )
    }

    private func setPositions(positions: [MenuPosition]) {
        tableSections
            .first(where: { $0.type == .positions })?
            .cellViewModels = positions.map { position in
                MenuCellViewModel(position: position)
            }
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

    class Section {
        let type: Type
        let headerViewModel: ViewModel?
        var cellViewModels: [ViewModel]

        init(type: Type, headerViewModel: ViewModel?, cellViewModels: [ViewModel]) {
            self.type = type
            self.headerViewModel = headerViewModel
            self.cellViewModels = cellViewModels
        }

        enum `Type` {
            case address
            case promotions
            case positions
        }
    }
}
