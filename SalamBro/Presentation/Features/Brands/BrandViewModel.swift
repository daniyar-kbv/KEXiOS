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
    var coordinator: BrandsCooridnator { get }
    var brands: [Brand] { get }
    var ratios: [(Float, Float)] { get }
    var updateCollectionView: BehaviorRelay<Void?> { get }
    func refreshBrands()
    func didSelect(index: Int, completion: (_ type: Any) -> Void)
    func getBrands()
}

final class BrandViewModel: BrandViewModelProtocol {
    private let disposeBag = DisposeBag()

    var coordinator: BrandsCooridnator
    private let repository: BrandRepository
    private let service: LocationService
    private let type: FlowType
    private let locationRepository: LocationRepository
    private(set) var brands: [Brand] = [] {
        didSet {
            updateRatio()
        }
    }

    var ratios: [(Float, Float)] = []
    var updateCollectionView: BehaviorRelay<Void?>
    private let didSelectBrand: ((Brand) -> Void)?

    init(coordinator: BrandsCooridnator,
         repository: BrandRepository,
         locationRepository: LocationRepository,
         service: LocationService,
         type: FlowType,
         didSelectBrand: ((Brand) -> Void)?)
    {
        self.coordinator = coordinator
        self.repository = repository
        self.locationRepository = locationRepository
        self.service = service
        self.type = type
        self.didSelectBrand = didSelectBrand
        updateCollectionView = .init(value: nil)
        makeBrandsRequest()
    }

    func getBrands() {
        if
            let cachedBrands = repository.getBrands(),
            cachedBrands != []
        {
            brands = cachedBrands
            updateCollectionView.accept(())
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

        updateCollectionView.accept(())
    }

    private func makeBrandsRequest() {
        guard let city = locationRepository.getCurrectCity() else { return }
        startAnimation()
        service.getBrands(for: city.id)
            .subscribe(onSuccess: { [weak self] brandsResponse in
                self?.stopAnimation()
                self?.process(receivedBrands: brandsResponse)
            }, onError: { [weak self] error in
                self?.stopAnimation()
                self?.coordinator.alert(error: error)
            })
            .disposed(by: disposeBag)
    }

    private func process(receivedBrands: [Brand]) {
        guard let cachedBrands = repository.getBrands() else {
            repository.set(brands: receivedBrands)
            brands = receivedBrands
            updateCollectionView.accept(())
            return
        }

        if cachedBrands == receivedBrands { return }
        repository.set(brands: receivedBrands)
        brands = receivedBrands
        updateCollectionView.accept(())
    }

    func refreshBrands() {
        makeBrandsRequest()
    }

    func didSelect(index: Int, completion: (_ type: Any) -> Void) {
        let brand = brands[index]
        repository.changeCurrent(brand: brand)
        didSelectBrand?(brand)
        switch type {
        case .firstFlow:
            coordinator.openMap(didSelectAddress: nil)
        case .changeAddress, .changeBrand:
            break
        }
        completion(type)
    }
    
    enum FlowType {
        case firstFlow
        case changeAddress(didSelectAddress: ((Address) -> Void)?)
        case changeBrand(didSave: (() -> Void)?)
    }
}
