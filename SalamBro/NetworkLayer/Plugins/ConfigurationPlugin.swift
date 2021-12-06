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
        let errorType = result.map { response -> ErrorType? in
            guard let errorResponse = try? response.map(ResponseWithErrorOnly.self) else {
                return nil
            }

            switch errorResponse.error.code {
            case Constants.ErrorCode.iosNotAvailable: return .appNotAvailable
            case Constants.ErrorCode.iosNotAvailable: return .deliveryChanged
            default: return nil
            }
        }

        switch try? errorType.get() {
        case .appNotAvailable:
            NotificationCenter.default.post(name: Constants.InternalNotification.appUnavailable.name, object: nil)
            return .failure(.underlying(EmptyError(), nil))
        case .deliveryChanged:
            return .failure(.underlying(NetworkError.deliveryChanged, nil))
        default:
            return result
        }
    }
}

extension ConfigurationPlugin {
    enum ErrorType {
        case appNotAvailable
        case deliveryChanged
    }
}
