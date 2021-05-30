//
//  AuthPlugin.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 31.05.2021.
//

import Moya

struct AuthPlugin: PluginType {
    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request

        NSLog("preparing request...")

        if let accessToken = AuthTokenStorageImpl.sharedStorage.token {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
