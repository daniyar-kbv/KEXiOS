//
//  YandexAPI.swift
//  SalamBro
//
//  Created by Dan on 9/10/21.
//

import Moya

enum RateAPI {
    case geocode()
}

extension RateAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.APIBase.dev
    }

    var path: String {
        switch self {
        case .getRates: return "orders/ratestars/"
        case .saveUserRate: return "orders/rates/"
        }
    }

    var method: Method {
        switch self {
        case .getRates: return .get
        case .saveUserRate: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .geocode: return .requestParameters(parameters: <#T##[String : Any]#>, encoding: <#T##ParameterEncoding#>)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
