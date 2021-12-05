//
//  PushNotificationsService.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol PushNotificationsService: AnyObject {
    func fcmTokenSave(dto: FCMTokenSaveDTO) -> Single<Void>
    func fcmTokenUpdate(dto: FCMTokenUpdateDTO) -> Single<Void>
}

final class PushNotificationsServiceMoyaImpl: PushNotificationsService {
    private let disposeBag = DisposeBag()

    private let provider: MoyaProvider<PushNotificationsAPI>

    init(provider: MoyaProvider<PushNotificationsAPI>) {
        self.provider = provider
    }

    func fcmTokenSave(dto: FCMTokenSaveDTO) -> Single<Void> {
        return provider.rx
            .request(.fcmTokenSave(dto: dto))
            .retryWhenDeliveryChanged()
            .map { response in
                guard let response = try? response.map(FCMTokenSaveResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard response.data != nil else {
                    throw NetworkError.noData
                }

                return ()
            }
    }

    func fcmTokenUpdate(dto: FCMTokenUpdateDTO) -> Single<Void> {
        return provider.rx
            .request(.fcmTokenUpdate(dto: dto))
            .retryWhenDeliveryChanged()
            .map { response in
                guard let response = try? response.map(FCMTokenUpdateResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard response.data != nil else {
                    throw NetworkError.noData
                }

                return ()
            }
    }
}
