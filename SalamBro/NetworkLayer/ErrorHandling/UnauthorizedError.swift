//
//  Observable.swift
//  SalamBro
//
//  Created by Dan on 8/10/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import WebKit

private var _authProvider: MoyaProvider<AuthAPI>?
private var _pushNotificationsProvider: MoyaProvider<PushNotificationsAPI>?
private let disposeBag = DisposeBag()

extension Single {
    static var authProvider: MoyaProvider<AuthAPI>? {
        get {
            _authProvider
        }
        set {
            _authProvider = newValue
        }
    }

    static var pushNotificationsProvider: MoyaProvider<PushNotificationsAPI>? {
        get {
            _pushNotificationsProvider
        }
        set {
            _pushNotificationsProvider = newValue
        }
    }

    private var authTokenStorage: AuthTokenStorage {
        return AuthTokenStorageImpl.sharedStorage
    }

    private func refreshToken() throws -> Single<Void> {
        let dto = RefreshDTO(refresh: authTokenStorage.refreshToken ?? "")
        guard let authProvider = Single<Any>.authProvider else { throw NetworkError.unauthorized }
        return authProvider
            .rx
            .request(.refreshToken(dto: dto))
            .map { response in
                guard response.response?.statusCode != Constants.StatusCode.unauthorized else {
                    authTokenStorage.cleanUp()
                    let dataStore = WKWebsiteDataStore.default()
                    dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                        dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                             for: records,
                                             completionHandler: {})
                    }
                    NotificationCenter.default.post(
                        name: Constants.InternalNotification.unauthorize.name,
                        object: ()
                    )
                    throw NetworkError.unauthorized
                }

                guard let refreshResponse = try? response.map(AccessTokenResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = refreshResponse.error {
                    throw error
                }

                guard let accessToken = refreshResponse.data else {
                    throw NetworkError.noData
                }

                authTokenStorage.persist(token: accessToken.access, refreshToken: accessToken.refresh)

                return ()
            }
    }

    private func sendNewFCMToken() throws -> Single<Void> {
        guard let pushNotificationsProvider = Single<Any>.pushNotificationsProvider,
              let fcmToken = DefaultStorageImpl.sharedStorage.fcmToken
        else { throw NetworkError.noData }
        return pushNotificationsProvider
            .rx
            .request(.fcmTokenSave(dto: .init(fcmToken: fcmToken)))
            .map { _ in () }
    }

    func retryWhenUnautharized() -> PrimitiveSequence<Trait, Element> {
        return retryWhen { source in
            source.flatMapLatest { error -> Single<Void> in
                guard (error as? MoyaError)?.response?.statusCode != Constants.StatusCode.unauthorized
                else {
                    do {
                        return try refreshToken()
                            .flatMap { _ -> Single<Void> in
                                do {
                                    return try sendNewFCMToken()
                                } catch {
                                    throw error
                                }
                            }
                    } catch {
                        throw error
                    }
                }
                return Single.error(error)
            }
        }
    }
}
