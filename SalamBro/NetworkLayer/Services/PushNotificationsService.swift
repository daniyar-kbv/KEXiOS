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
    func fcmTokenUpdate(dto: FCMTokenUpdateDTO) -> Single<Void>
    func fcmTokenLogin(leadUUID: String) -> Single<Void>
    func fcmTokenCreate(dto: FCMTokenCreateDTO) -> Single<Void>
}

final class PushNotificationsServiceMoyaImpl: PushNotificationsService {
    private let disposeBag = DisposeBag()

    private let provider: MoyaProvider<PushNotificationsAPI>

    init(provider: MoyaProvider<PushNotificationsAPI>) {
        self.provider = provider
    }

    func fcmTokenUpdate(dto: FCMTokenUpdateDTO) -> Single<Void> {
        return provider.rx
            .request(.fcmTokenUpdate(dto: dto))
            .map { response in
                guard let response = try? response.map(PushNotificationsFCMTokenUpdateResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let _ = response.data else {
                    throw NetworkError.noData
                }

                return ()
            }
    }

    func fcmTokenLogin(leadUUID: String) -> Single<Void> {
        return provider.rx
            .request(.fcmTokenLogin(leadUUID: leadUUID))
            .map { response in
                guard let response = try? response.map(PushNotificationsFCMTokenLoginResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let _ = response.data else {
                    throw NetworkError.noData
                }

                return ()
            }
    }

    func fcmTokenCreate(dto: FCMTokenCreateDTO) -> Single<Void> {
        return provider.rx
            .request(.fcmTokenCreate(dto: dto))
            .map { response in
                guard let response = try? response.map(PushNotificationsFCMTokenCreateResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let _ = response.data else {
                    throw NetworkError.noData
                }

                return ()
            }
    }
}
