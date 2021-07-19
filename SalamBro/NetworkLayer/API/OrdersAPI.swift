//
//  OrdersAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Moya

//  Tech debt: change cart requests

enum OrdersAPI {
    case apply(dto: OrderApplyDTO?)
    case getProducts(leadUUID: String)
    case getProductDetail(leadUUID: String, productUUID: String)
    case getCart(leadUUID: String)
    case updateCart(leadUUID: String, dto: CartDTO)
}

extension OrdersAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .apply: return "orders/apply/"
        case let .getProducts(leadUUID): return "orders/\(leadUUID)/nomenclature/"
        case let .getProductDetail(leadUUID, productUUID): return "orders/\(leadUUID)/nomenclature/\(productUUID)/"
        case let .getCart(leadUUID): return "orders/\(leadUUID)/cart/"
        case let .updateCart(leadUUID, _): return "orders/\(leadUUID)/cart/"
        }
    }

    var method: Method {
        switch self {
        case .apply: return .post
        case .getProducts: return .get
        case .getProductDetail: return .get
        case .getCart: return .get
        case .updateCart: return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .apply(dto): return .requestJSONEncodable(dto)
        case .getProducts: return .requestPlain
        case .getProductDetail: return .requestPlain
        case .getCart: return .requestPlain
        case let .updateCart(_, dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
