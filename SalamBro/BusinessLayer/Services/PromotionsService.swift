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
    func getPromotions() -> Single<PromotionsResponse>
}

class PromotionsServiceImpl: PromotionsService {
    private let provider: MoyaProvider<PromotionsAPI>

    init(provider: MoyaProvider<PromotionsAPI>) {
        self.provider = provider
    }
    
    func getPromotions() -> Single<PromotionsResponse> {
        return provider.rx
            .request(.promotions)
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let promotionsResponse = try? response.map(PromotionsResponse.self) else {
                    throw NetworkError.badMapping
                }

                return promotionsResponse
            }
    }
}
