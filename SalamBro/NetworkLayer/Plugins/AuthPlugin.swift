//
//  AuthPlugin.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Moya

struct AuthPlugin: PluginType {
    private let authTokenStorage: AuthTokenStorage

    init(authTokenStorage: AuthTokenStorage) {
        self.authTokenStorage = authTokenStorage
    }

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request

        if let accessToken = AuthTokenStorageImpl.sharedStorage.token {
            request.addValue("JWT \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    func process(_ result: Result<Response, MoyaError>, target _: TargetType) -> Result<Response, MoyaError> {
        if (try? result.get().response?.statusCode == 401) ?? false {
            authTokenStorage.cleanUp()
        }

        return result
    }
}
