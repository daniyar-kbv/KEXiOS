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
    private let brandStorage: BrandStorage
    private let geoStorage: GeoStorage

    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let locationService: LocationService

    init(locationService: LocationService,
         brandStorage: BrandStorage,
         geoStorage: GeoStorage)
    {
        self.locationService = locationService
        self.brandStorage = brandStorage
        self.geoStorage = geoStorage
    }

    func getBrands() -> [Brand]? {
        guard
            let brands = brandStorage.brands,
            brands != []
        else {
            return nil
        }
        return brands
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

    func setBrands(brands: [Brand]) {
        brandStorage.brands = brands
    }

    func getCurrentBrand() -> Brand? {
        return geoStorage.userAddresses.first(where: { $0.isCurrent })?.brand
    }

    func changeCurrentBrand(to brand: Brand) {
        guard let index = geoStorage.userAddresses.firstIndex(where: { $0.isCurrent }) else { return }
        let userAddresses = geoStorage.userAddresses
        userAddresses[index].brand = brand
        geoStorage.userAddresses = userAddresses
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
