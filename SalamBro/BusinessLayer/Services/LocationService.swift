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
}

final class LocationServiceMoyaImpl: LocationService {
    private let disposeBag = DisposeBag()
    private let provider: MoyaProvider<LocationAPI>

    init(provider: MoyaProvider<LocationAPI>) {
        self.provider = provider
    }

    func getAllCountries() -> Single<[Country]> {
        return provider.rx.request(.getAllCountries)
            .map { response in
                guard let countryResponse = try? response.map(CountriesResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = countryResponse.error {
                    throw NetworkError.error(error)
                }

                return countryResponse.data.results
            }
    }
}
