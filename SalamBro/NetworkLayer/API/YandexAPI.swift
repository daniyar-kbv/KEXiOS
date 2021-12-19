//
//  YandexAPI.swift
//  SalamBro
//
//  Created by Dan on 9/10/21.
//

import Moya

enum YandexAPI {
    case geocode(dto: YandexDTO)
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
        case let .geocode(dto):
            return .requestParameters(parameters: dto.toQueryParams(), encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
