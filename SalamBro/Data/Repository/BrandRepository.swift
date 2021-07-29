//
//  BrandRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol BrandRepository: AnyObject {
    var outputs: BrandRepositoryImpl.Output { get }

    func getBrands() -> [Brand]?
    func getCurrentBrand() -> Brand?
    func fetchBrands(with cityId: Int)
    func changeCurrentBrand(to brand: Brand)
    func setBrands(brands: [Brand])
}

final class BrandRepositoryImpl: BrandRepository {
    private let storage: BrandStorage

    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let locationService: LocationService

    init(locationService: LocationService, storage: BrandStorage) {
        self.locationService = locationService
        self.storage = storage
    }

    func getBrands() -> [Brand]? {
        guard
            let brands = storage.brands,
            brands != []
        else {
            return nil
        }
        return brands
    }

    func getCurrentBrand() -> Brand? {
        return storage.brand
    }

    func fetchBrands(with cityId: Int) {
        outputs.didStartRequest.accept(())
        locationService.getBrands(for: cityId)
            .subscribe(onSuccess: { [weak self] brandsResponse in
                self?.outputs.didEndRequest.accept(())
                self?.setBrands(brands: brandsResponse)
                self?.outputs.didGetBrands.accept(brandsResponse)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                    return
                }
                self?.outputs.didFail.accept(NetworkError.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }

    func changeCurrentBrand(to brand: Brand) {
        storage.brand = brand
    }

    func setBrands(brands: [Brand]) {
        storage.brands = brands
    }
}

extension BrandRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didGetBrands = PublishRelay<[Brand]>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
    }
}
