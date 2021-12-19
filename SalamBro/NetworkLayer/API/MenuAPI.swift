//
//  ProotionsAPI.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Moya

enum MenuAPI {
    case products
    case productDetail(productUUID: String)
    case promotions
    case promotionDetail(id: Int)
}

extension MenuAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.apiBaseURL
    }

    var path: String {
        switch self {
        case .products: return "orders/\(Constants.URLVariables.leadUUID)/nomenclature/"
        case let .productDetail(productUUID): return
            "orders/\(Constants.URLVariables.leadUUID)/nomenclature/\(productUUID)/"
        case .promotions: return "/promotions/\(Constants.URLVariables.leadUUID)/"
        case let .promotionDetail(id): return "/promotions/\(Constants.URLVariables.leadUUID)/\(id)/"
        }
    }

    var method: Method {
        switch self {
        case .products: return .get
        case .productDetail: return .get
        case .promotions: return .get
        case .promotionDetail: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .products: return .requestPlain
        case .productDetail: return .requestPlain
        case .promotions: return .requestPlain
        case .promotionDetail: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
