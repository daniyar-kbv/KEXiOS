//
//  LocationService.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 26.05.2021.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol LocationService: AnyObject {
    func getAllCountries() -> Single<[Country]>
    func getCities(for countryId: Int) -> Single<[City]>
    func getBrands(for cityId: Int) -> Single<[Brand]>
}

final class LocationServiceMoyaImpl: LocationService {
    private let provider: MoyaProvider<LocationAPI>

    init(provider: MoyaProvider<LocationAPI>) {
        self.provider = provider
    }

    func getAllCountries() -> Single<[Country]> {
        return provider.rx
            .request(.getAllCountries)
            .retryWhenDeliveryChanged()
            .map { response in
                guard let countryResponse = try? response.map(CountriesResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = countryResponse.error {
                    throw error
                }

                guard let data = countryResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func getCities(for countryId: Int) -> Single<[City]> {
        return provider.rx
            .request(.getCities(countryId: countryId))
            .retryWhenDeliveryChanged()
            .map { response in
                guard let citiesResponse = try? response.map(CitiesResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = citiesResponse.error {
                    throw error
                }

                guard let data = citiesResponse.data else {
                    throw NetworkError.noData
                }

                return data.cities
            }
    }

    func getBrands(for cityId: Int) -> Single<[Brand]> {
        provider.rx
            .request(.getCityBrands(cityId: cityId))
            .retryWhenDeliveryChanged()
            .map { response in
                guard let brandsResponse = try? response.map(BrandResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = brandsResponse.error {
                    throw NetworkError.error(error)
                }

                return brandsResponse.data
            }
    }
}
