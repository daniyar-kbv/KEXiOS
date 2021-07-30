//
//  PromotionsService.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol PromotionsService: AnyObject {
    func getPromotions(leadUUID: String) -> Single<[Promotion]>
}

class PromotionsServiceImpl: PromotionsService {
    private let provider: MoyaProvider<PromotionsAPI>

    init(provider: MoyaProvider<PromotionsAPI>) {
        self.provider = provider
    }

    func getPromotions(leadUUID: String) -> Single<[Promotion]> {
        return provider.rx
            .request(.promotions(leadUUID: leadUUID))
            .map { response in
                guard let promotionsResponse = try? response.map(PromotionsResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let promotions = promotionsResponse.data?.results else {
                    throw NetworkError.noData
                }

                return promotions
            }
    }
}
