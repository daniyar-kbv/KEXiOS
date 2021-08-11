//
//  ProotionsAPI.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Moya

enum MenuAPI {
    case promotions(leadUUID: String)
    case products(leadUUID: String)
    case productDetail(leadUUID: String, productUUID: String)
}

extension MenuAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case let .promotions(leadUUID): return "/promotions/\(leadUUID)/"
        case let .products(leadUUID): return "orders/\(leadUUID)/nomenclature/"
        case let .productDetail(leadUUID, productUUID): return
            "orders/\(leadUUID)/nomenclature/\(productUUID)/"
        }
    }

    var method: Method {
        switch self {
        case .promotions: return .get
        case .products: return .get
        case .productDetail: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .promotions: return .requestPlain
        case .products: return .requestPlain
        case .productDetail: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
