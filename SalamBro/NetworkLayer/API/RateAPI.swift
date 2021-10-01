//
//  RateApi.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/9/21.
//

import Moya

enum RateAPI {
    case getRates
    case saveUserRate(dto: UserRateDTO)
}

extension RateAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.APIBase.dev
    }

    var path: String {
        switch self {
        case .getRates: return "rates/stars/"
        case .saveUserRate: return "rates/"
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
        case .getRates: return .requestPlain
        case let .saveUserRate(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
