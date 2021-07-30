//
//  CountriesRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/3/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CountriesRepository: AnyObject {
    var outputs: CountriesRepositoryImpl.Output { get }

    func fetchCountries()
    func getCountries() -> [Country]?
    func changeCurrentCountry(to country: Country)
    func setCountries(countries: [Country])
}

final class CountriesRepositoryImpl: CountriesRepository {
    private let storage: GeoStorage

    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let locationService: LocationService

    init(locationService: LocationService, storage: GeoStorage) {
        self.locationService = locationService
        self.storage = storage
    }

    func fetchCountries() {
        outputs.didStartRequest.accept(())
        locationService.getAllCountries()
            .subscribe(onSuccess: { [weak self] countriesResponse in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetCountries.accept(countriesResponse)
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

    func getCountries() -> [Country]? {
        guard
            let countries = storage.countries,
            countries != []
        else {
            return nil
        }

        return countries
    }

    func changeCurrentCountry(to country: Country) {
        if let index = storage.userAddresses.firstIndex(where: { $0.isCurrent }) {
            let userAddresses = storage.userAddresses
            userAddresses[index].address.country = country
            storage.userAddresses = userAddresses
        } else {
            let newUserAddress = UserAddress()
            newUserAddress.address.country = country
            newUserAddress.isCurrent = true
            storage.userAddresses.append(newUserAddress)
        }
    }

    func setCountries(countries: [Country]) {
        storage.countries = countries
    }
}

extension CountriesRepositoryImpl {
    struct Output {
        let didGetCountries = PublishRelay<[Country]>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
