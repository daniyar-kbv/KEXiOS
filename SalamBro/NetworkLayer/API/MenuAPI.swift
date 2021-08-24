//
//  ProotionsAPI.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Moya

enum MenuAPI {
    case products(leadUUID: String)
    case productDetail(leadUUID: String, productUUID: String)
    case promotions(leadUUID: String)
    case participate
    case promotionDetail(leadUUID: String, id: Int)
}

extension MenuAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case let .products(leadUUID): return "orders/\(leadUUID)/nomenclature/"
        case let .productDetail(leadUUID, productUUID): return
            "orders/\(leadUUID)/nomenclature/\(productUUID)/"
        case let .promotions(leadUUID): return "/promotions/\(leadUUID)/"
        case .participate: return "/promotions/participate/"
        case let .promotionDetail(leadUUID, id): return "/promotions/\(leadUUID)/\(id)/"
        }
    }

    var method: Method {
        switch self {
        case .products: return .get
        case .productDetail: return .get
        case .promotions: return .get
        case .participate: return .post
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
        case .participate: return .requestPlain
        case .promotionDetail: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
