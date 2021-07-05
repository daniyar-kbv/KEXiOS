//
//  CitiesRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/1/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CitiesRepository: AnyObject {
    var outputs: CitiesRepositoryImpl.Output { get }

    func fetchCities(with countryId: Int)
    func getCities() -> [City]?
    func changeCurrentCity(to city: City)
    func setCities(cities: [City])
}

final class CitiesRepositoryImpl: CitiesRepository {
    private let storage: GeoStorage

    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let locationService: LocationService

    init(locationService: LocationService, storage: GeoStorage) {
        self.locationService = locationService
        self.storage = storage
    }

    func fetchCities(with countryId: Int) {
        outputs.didStartRequest.accept(())
        locationService.getCities(for: countryId)
            .subscribe(onSuccess: { [weak self] citiesResponse in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetCities.accept(citiesResponse)
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

    func getCities() -> [City]? {
        guard
            let cities = storage.cities,
            cities != []
        else {
            return nil
        }

        return cities
    }

    func changeCurrentCity(to city: City) {
        if let index = storage.currentDeliveryAddressIndex {
            storage.deliveryAddresses[index].city = city
        } else {
            storage.deliveryAddresses.append(DeliveryAddress(city: city))
            storage.currentDeliveryAddressIndex = storage.deliveryAddresses.firstIndex(where: { $0 == DeliveryAddress(city: city) })
        }
    }

    func setCities(cities: [City]) {
        storage.cities = cities
    }
}

extension CitiesRepositoryImpl {
    struct Output {
        let didGetCities = PublishRelay<[City]>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
