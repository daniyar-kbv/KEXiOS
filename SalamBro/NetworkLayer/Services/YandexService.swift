//
//  YandexService.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 9/10/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol YandexService: AnyObject {
    func getAddress(geocode: String) -> Single<YandexResponse>
}

final class YandexServiceMoyaImpl: YandexService {
    private let provider: MoyaProvider<YandexAPI>

    init(provider: MoyaProvider<YandexAPI>) {
        self.provider = provider
    }

    func getAddress(geocode: String) -> Single<YandexResponse> {
        return provider.rx.request(.geocode(geocode: geocode))
            .map { response in
                guard let response = try? response.map(YandexAddress.self) else {
                    throw NetworkError.badMapping
                }

                guard let addressResponse = response.response else {
                    throw NetworkError.noData
                }

                return addressResponse
            }
    }
}
