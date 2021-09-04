//
//  RateService.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/9/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol RateService: AnyObject {
    func getRates() -> Single<[RateStarList]>
    func setUserRate(with dto: UserRateDTO) -> Single<UserRateResponse>
}

final class RateServiceImpl: RateService {
    private let disposeBag = DisposeBag()

    private let provider: MoyaProvider<RateAPI>

    init(provider: MoyaProvider<RateAPI>) {
        self.provider = provider
    }

    func getRates() -> Single<[RateStarList]> {
        return provider.rx
            .request(.getRates)
            .map { response in
                guard
                    let ratesContainerResponse = try? response.map(RateResponseContainer.self)
                else {
                    throw NetworkError.badMapping
                }

                if let error = ratesContainerResponse.error {
                    throw error
                }

                guard let rates = ratesContainerResponse.data else {
                    throw NetworkError.badMapping
                }

                return rates
            }
    }

    func setUserRate(with dto: UserRateDTO) -> Single<UserRateResponse> {
        return provider.rx
            .request(.saveUserRate(dto: dto))
            .map { response in
                guard let userRateResponse = try? response.map(UserRateResponseContainer.self) else {
                    throw NetworkError.badMapping
                }

                if let error = userRateResponse.error {
                    throw error
                }

                guard let userRate = userRateResponse.data else {
                    throw NetworkError.badMapping
                }

                return userRate
            }
    }
}
