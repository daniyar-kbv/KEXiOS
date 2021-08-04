//
//  LanguagePlugin.swift
//  SalamBro
//
//  Created by Dan on 8/3/21.
//

import Foundation
import Moya

struct LanguagePlugin: PluginType {
    private let defaultStorage: DefaultStorage

    init(defaultStorage: DefaultStorage) {
        self.defaultStorage = defaultStorage
    }

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request

        request.addValue(defaultStorage.appLocale.code, forHTTPHeaderField: "Accept-Language")

        return request
    }
}
