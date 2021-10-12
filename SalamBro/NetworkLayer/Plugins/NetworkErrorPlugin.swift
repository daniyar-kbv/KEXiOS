//
//  NetworkErrorPlugin.swift
//  SalamBro
//
//  Created by Dan on 10/11/21.
//

import Foundation
import Moya

final class NetworkErrorPlugin: PluginType {
    func process(_ result: Result<Moya.Response, MoyaError>, target _: TargetType) -> Result<Moya.Response, MoyaError> {
        switch result {
        case .success: return result
        case let .failure(error):
            switch error {
            case let .underlying(error, _):
                guard (error.asAFError?.isSessionTaskError) == true else { return result }
//                Tech debt: refactor
//                Да, костыль, ну а что делать?
                let json = [
                    "data": nil,
                    "error": [
                        "code": Constants.ErrorCode.localNetworkConnection,
                        "message": SBLocalization.localized(key: ErrorText.Network.internetConnection),
                    ],
                ]

                guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                else { return result }

                return .success(.init(statusCode: 400, data: jsonData))
            default: return result
            }
        }
    }
}
