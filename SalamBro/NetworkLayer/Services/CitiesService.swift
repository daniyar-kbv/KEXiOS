//
//  CitiesService.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/1/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol CitiesService: AnyObject {
    func getCities(countryId: Int) -> Single<CityResponse>
}

final class CitiesServiceMoyaImpl: CitiesService {
    private let disposeBag = DisposeBag()

    private let provider: MoyaProvider<CitiesAPI>

    init(provider: MoyaProvider<CitiesAPI>) {
        self.provider = provider
    }

    func getCities(countryId: Int) -> Single<CityResponse> {
        return provider.rx
            .request(.getCities(countryId: countryId))
            .map { response in
                guard
                    let citiesContainerResponse = try? response.map(CityResponseContainer.self)
                else {
                    throw NetworkError.badMapping
                }

                if let error = citiesContainerResponse.error {
                    throw error
                }

                guard let cities = citiesContainerResponse.data else {
                    throw NetworkError.badMapping
                }

                return cities
            }
    }
}
