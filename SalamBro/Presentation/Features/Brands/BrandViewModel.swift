//
//  BrandViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

protocol BrandViewModelProtocol: ViewModel {
    var outputs: BrandViewModel.Outputs { get }
    var brands: [Brand] { get }
    var ratios: [(CGFloat, CGFloat)] { get }

    func refreshBrands()
    func didSelect(index: Int)
    func getBrands()
}

final class BrandViewModel: BrandViewModelProtocol {
    let outputs = Outputs()

    private let cityId: Int
    private let disposeBag = DisposeBag()

    private let repository: BrandRepository
    private let service: LocationService
    private let locationRepository: LocationRepository
    private(set) var brands: [Brand] = [] {
        didSet {
            updateRatio()
        }
    }

    private var cellSizeSequence: [BrandCellSizeType] = [.square, .horizontalShort, .vertical, .square, .square, .horizontalLong]
    var ratios: [(CGFloat, CGFloat)] = []

    init(repository: BrandRepository,
         locationRepository: LocationRepository,
         service: LocationService,
         cityId: Int)
    {
        self.cityId = cityId
        self.repository = repository
        self.locationRepository = locationRepository
        self.service = service

        makeBrandsRequest()
    }

    func getBrands() {
        if
            let cachedBrands = repository.getBrands(),
            cachedBrands != []
        {
            brands = cachedBrands
        }

        makeBrandsRequest()
    }

    private func updateRatio() {
        for index in 0 ..< brands.count {
            ratios.append(cellSizeSequence[index % cellSizeSequence.count].ratio)
        }

        outputs.didGetBrands.accept(())
    }

    private func makeBrandsRequest() {
        startAnimation()
        service.getBrands(for: cityId)
            .subscribe(onSuccess: { [weak self] brandsResponse in
                self?.stopAnimation()
                self?.process(receivedBrands: brandsResponse)
            }, onError: { [weak self] error in
                self?.stopAnimation()
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            })
            .disposed(by: disposeBag)
    }

    private func process(receivedBrands: [Brand]) {
        guard let cachedBrands = repository.getBrands() else {
            repository.set(brands: receivedBrands)
            brands = receivedBrands
            return
        }

        if cachedBrands == receivedBrands { return }
        repository.set(brands: receivedBrands)
        brands = receivedBrands
    }

    func refreshBrands() {
        makeBrandsRequest()
    }

    func didSelect(index: Int) {
        let brand = brands[index]
        repository.changeCurrent(brand: brand)
        outputs.didSelectBrand.accept(brand)
    }
}

extension BrandViewModel {
    struct Outputs {
        let didGetBrands = BehaviorRelay<Void>(value: ())
        let didGetError = PublishRelay<ErrorPresentable?>()
        let didSelectBrand = PublishRelay<Brand>()
    }
}

extension BrandViewModel {
    private enum FlowType {
        case firstFlow
        case changeAddress(didSelectAddress: ((Address) -> Void)?)
        case changeBrand(didSave: (() -> Void)?)
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
