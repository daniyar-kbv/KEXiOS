//
//  YandexAPI.swift
//  SalamBro
//
//  Created by Dan on 9/10/21.
//

import Moya

enum YandexAPI {
    case geocode(geocode: String)
}

extension YandexAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.yandexURL
    }

    var path: String {
        switch self {
        case .geocode: return "1.x/"
        }
    }

    var method: Method {
        switch self {
        case .geocode: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .geocode(geocode):
            let params = ["geocode": geocode,
                          "apikey": "7cd03aed-4c1a-460a-aca2-90ae52dd60b6",
                          "lang": "ru_RU",
                          "format": "json",
                          "sco": "latlong",
                          "kind": "house",
                          "results": "1"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
