//
//  LanguagePlugin.swift
//  SalamBro
//
//  Created by Dan on 8/3/21.
//

import Foundation
import Moya

struct ConfigurationPlugin: PluginType {
    private let defaultStorage: DefaultStorage

    init(defaultStorage: DefaultStorage) {
        self.defaultStorage = defaultStorage
    }

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request

        request.addValue(defaultStorage.appLocale.code, forHTTPHeaderField: "language")
        request.addValue("IOS", forHTTPHeaderField: "User-Agent")

        if let fcmToken = defaultStorage.fcmToken {
            request.addValue(fcmToken, forHTTPHeaderField: "X-NOTIFICATION-TOKEN")
        }

        return request
    }

    func process(_ result: Result<Response, MoyaError>, target _: TargetType) -> Result<Response, MoyaError> {
        let isAvailable = result.map { response -> Bool in
            guard let errorResponse = try? response.map(ResponseWithErrorOnly.self) else {
                return true
            }

            guard errorResponse.error.code == Constants.ErrorCode.iosNotAvailable else {
                return true
            }

            return false
        }

        guard (try? isAvailable.get()) ?? true else {
            NotificationCenter.default.post(name: Constants.InternalNotification.appUnavailable.name, object: nil)
            return .failure(.underlying(EmptyError(), nil))
        }

        return result
    }
}
