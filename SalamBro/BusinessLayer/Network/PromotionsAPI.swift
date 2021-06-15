//
//  ProotionsAPI.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Moya

enum PromotionsAPI {
    case promotions
}

extension PromotionsAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .promotions:
            return "/promotions/"
        }
    }

    var method: Method {
        switch self {
        case .promotions: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .promotions: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

