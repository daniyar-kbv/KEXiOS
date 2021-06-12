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
    var ratios: [(Float, Float)] { get }

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

    var ratios: [(Float, Float)] = []

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
            outputs.didGetBrands.accept(())
        }

        makeBrandsRequest()
    }

    private func updateRatio() {
        for (index, _) in brands.enumerated() {
            switch (index + 1) % 4 {
            case 1:
                ratios.append((1.0, 0.42))
            case 2:
                ratios.append((0.58, 0.88))
            case 3:
                ratios.append((0.58, 0.42))
            case 4:
                ratios.append((0.42, 0.42))
            default:
                ratios.append((0.0, 0.0))
            }
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
            outputs.didGetBrands.accept(())
            return
        }

        if cachedBrands == receivedBrands { return }
        repository.set(brands: receivedBrands)
        brands = receivedBrands
        outputs.didGetBrands.accept(())
    }

    func refreshBrands() {
        makeBrandsRequest()
    }

    func didSelect(index: Int) {
        let brand = brands[index]
        repository.changeCurrent(brand: brand)
        outputs.didSelectBrand.accept(brand)
    }

    enum FlowType {
        case firstFlow
        case changeAddress(didSelectAddress: ((Address) -> Void)?)
        case changeBrand(didSave: (() -> Void)?)
    }
}

extension BrandViewModel {
    struct Outputs {
        let didGetBrands = BehaviorRelay<Void>(value: ())
        let didGetError = PublishRelay<ErrorPresentable?>()
        let didSelectBrand = PublishRelay<Brand>()
    }
}
