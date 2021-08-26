//
//  AuthorizedPromotionsService.swift
//  SalamBro
//
//  Created by Dan on 8/26/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol AuthorizedPromotionsService: AnyObject {
    func sendPartticipate(dto: PromotionsParticipateDTO) -> Single<Void>
}

final class AuthorizedPromotionsServiceImpl: AuthorizedPromotionsService {
    private let provider: MoyaProvider<MenuAPI>

    init(provider: MoyaProvider<MenuAPI>) {
        self.provider = provider
    }

    func sendPartticipate(dto: PromotionsParticipateDTO) -> Single<Void> {
        return provider.rx
            .request(.participate(dto: dto))
            .map { response in
                guard let response = try? response.map(PromotionsParticipateResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                return ()
            }
    }
}
