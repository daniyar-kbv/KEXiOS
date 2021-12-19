//
//  AuthorizedApplyService.swift
//  SalamBro
//
//  Created by Dan on 8/12/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol AuthorizedApplyService: AnyObject {
    func authorizedApply(dto: OrderApplyDTO?) -> Single<String>
}

final class AuthorizedApplyServiceImpl: AuthorizedApplyService {
    private let provider: MoyaProvider<OrdersAPI>

    init(provider: MoyaProvider<OrdersAPI>) {
        self.provider = provider
    }

    func authorizedApply(dto: OrderApplyDTO?) -> Single<String> {
        return provider.rx
            .request(.authorizedApply(dto: dto))
            .retryWhenDeliveryChanged()
            .map { response in

                guard let applyResponse = try? response.map(OrderApplyResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = applyResponse.error {
                    throw error
                }

                guard let leadUUID = applyResponse.data?.uuid else {
                    throw NetworkError.noData
                }

                return leadUUID
            }
    }
}
