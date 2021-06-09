//
//  OrdersAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Moya

enum OrdersAPI {
    case apply(dto: OrderApplyDTO)
    case decrement(dto: OrderIncDecrDTO)
    case increment(dto: OrderIncDecrDTO)
    case getProducts(leadUUID: String)
    case updateCart(leadUUID: String)
}

extension OrdersAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .apply: return "orders/apply/"
        case let .decrement(dto): return "orders/\(dto.leadUUID)/decrement/\(dto.positionUUID)"
        case let .increment(dto): return "orders/\(dto.leadUUID)/increment/\(dto.positionUUID)"
        case let .getProducts(leadUUID): return "orders/\(leadUUID)/nomenclature/"
        case let .updateCart(leadUUID): return "orders/\(leadUUID)/update-cart"
        }
    }

    var method: Method {
        switch self {
        case .apply: return .post
        case .decrement: return .post
        case .increment: return .post
        case .getProducts: return .get
        case .updateCart: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .apply(dto): return .requestJSONEncodable(dto)
        case .decrement: return .requestPlain
        case .increment: return .requestPlain
        case .getProducts: return .requestPlain
        case .updateCart: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
