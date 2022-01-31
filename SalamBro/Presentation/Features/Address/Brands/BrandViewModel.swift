//
//  BrandViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol BrandViewModelProtocol: ViewModel {
    var outputs: BrandViewModel.Outputs { get }

    var brands: [Brand] { get }
    var ratios: [(CGFloat, CGFloat)] { get }

    func getBrands()
    func didSelect(index: Int)
}

final class BrandViewModel: BrandViewModelProtocol {
    private(set) var outputs: Outputs = .init()

    private let disposeBag = DisposeBag()

    private let brandsRepository: BrandRepository
    private let addressRepository: AddressRepository

    let flowType: FlowType
    private lazy var cityId: Int? = {
        switch flowType {
        case let .changeAddress(cityId): return cityId
        case .changeBrand, .create: return addressRepository.getCurrentCity()?.id
        }
    }()

    private(set) var brands: [Brand] = [] {
        didSet {
            updateRatio()
        }
    }

    private var selectedIndex: Int?

    private var cellSizeSequence: [BrandCellSizeType] = [.square, .horizontalShort, .vertical, .square, .square, .horizontalLong]
    var ratios: [(CGFloat, CGFloat)] = []

    init(brandsRepository: BrandRepository,
         addressRepository: AddressRepository,
         flowType: FlowType)
    {
        self.brandsRepository = brandsRepository
        self.addressRepository = addressRepository
        self.flowType = flowType

        bindBrandsRepository()
        bindAddressRepository()
    }

    func getBrands() {
        guard let cityId = cityId else { return }

        brandsRepository.fetchBrands(with: cityId)
    }

    func didSelect(index: Int) {
        selectedIndex = index

        guard brands[index].isAvailable == true else { return }
        switch flowType {
        case .changeAddress:
            outputs.didSelectBrand.accept(brands[index])
        case .create:
            brandsRepository.changeCurrentBrand(to: brands[index])
            guard let deliveryAddress = addressRepository.getCurrentUserAddress()
            else { return }
            outputs.toMap.accept(deliveryAddress)
        case .changeBrand:
            guard let addressId = addressRepository.getCurrentUserAddress()?.id
            else { return }
            addressRepository.updateUserAddress(with: addressId,
                                                brandId: brands[index].id)
        }
    }

    private func bindBrandsRepository() {
        brandsRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        brandsRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        brandsRepository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)

        brandsRepository.outputs.didGetBrands
            .bind {
                [weak self] brands in
                    self?.brands = brands
                    self?.outputs.didRefreshCollectionView.accept(())
                    self?.outputs.didGetBrands.accept(())
            }
            .disposed(by: disposeBag)
    }

    private func bindAddressRepository() {
        addressRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didSaveUserAddress
            .subscribe(onNext: { [weak self] in
                guard let selectedIndex = self?.selectedIndex,
                      let brand = self?.brands[selectedIndex]
                else { return }

                self?.outputs.didSelectBrand.accept(brand)
            })
            .disposed(by: disposeBag)

        addressRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }

    private func updateRatio() {
        for index in 0 ..< brands.count {
            ratios.append(cellSizeSequence[index % cellSizeSequence.count].ratio)
        }
    }
}

extension BrandViewModel {
    struct Outputs {
        let didStartRequest = PublishRelay<Void>()
        let didGetBrands = BehaviorRelay<Void>(value: ())
        let didSelectBrand = PublishRelay<Brand>()
        let toMap = PublishRelay<UserAddress>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didEndRequest = PublishRelay<Void>()
        let didRefreshCollectionView = PublishRelay<Void>()
    }
}

extension BrandViewModel {
    internal enum FlowType {
        case create
        case changeAddress(cityId: Int)
        case changeBrand
    }

    private enum BrandCellSizeType {
        case square
        case horizontalShort
        case horizontalLong
        case vertical

//        MARK: Size rations according to design

        private static let fullSize: CGFloat = 343

        var ratio: (CGFloat, CGFloat) {
            switch self {
            case .square:
                return (146 / Self.fullSize,
                        146 / Self.fullSize)
            case .horizontalShort:
                return (197 / Self.fullSize,
                        146 / Self.fullSize)
            case .horizontalLong:
                return (Self.fullSize / Self.fullSize,
                        146 / Self.fullSize)
            case .vertical:
                return (197 / Self.fullSize,
                        292 / Self.fullSize)
            }
        }
    }
}
