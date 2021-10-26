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
}
