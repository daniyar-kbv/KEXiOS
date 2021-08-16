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

private var _authProvider = MoyaProvider<AuthAPI>()
private let disposeBag = DisposeBag()

extension Single {
    static var authProvider: MoyaProvider<AuthAPI> {
        get {
            _authProvider
        }
        set {
            _authProvider = newValue
        }
    }

    private var authTokenStorage: AuthTokenStorage {
        return AuthTokenStorageImpl.sharedStorage
    }

    private func refreshToken() -> Single<Void> {
        let dto = RefreshDTO(refresh: authTokenStorage.refreshToken ?? "")
        return Single<Any>.authProvider
            .rx
            .request(.refreshToken(dto: dto))
            .map { response in
                guard response.response?.statusCode != Constants.StatusCode.unauthorized else {
                    authTokenStorage.cleanUp()
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

    func retryWhenUnautharized() -> PrimitiveSequence<Trait, Element> {
        return retryWhen { source in
            source.flatMapLatest { error -> Single<Void> in
                guard (error as? MoyaError)?.response?.statusCode != Constants.StatusCode.unauthorized
                else {
                    return refreshToken()
                }
                return Single.error(error)
            }
        }
    }
}
