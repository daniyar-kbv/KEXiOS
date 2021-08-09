//
//  OrdersAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Moya

enum OrdersAPI {
    case apply(dto: OrderApplyDTO)
    case authorizedApply
    case authorizedApplyWithAddress(dto: OrderApplyDTO)
    case getProducts(leadUUID: String)
    case getProductDetail(leadUUID: String, productUUID: String)
    case additionalNomenclature(leadUUID: String)
    case getCart(leadUUID: String)
    case updateCart(leadUUID: String, dto: CartDTO)
    case applyPromocode(promocode: String)
}

extension OrdersAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .apply: return "orders/apply/"
        case .authorizedApply: return "/orders/authorized-apply/"
        case .authorizedApplyWithAddress: return "/orders/authorized-apply-with-address/"
        case let .getProducts(leadUUID): return "orders/\(leadUUID)/nomenclature/"
        case let .getProductDetail(leadUUID, productUUID): return
            "orders/\(leadUUID)/nomenclature/\(productUUID)/"
        case let .additionalNomenclature(leadUUID): return "/orders/\(leadUUID)/additional-nomenclature/"
        case let .getCart(leadUUID): return "orders/\(leadUUID)/cart/"
        case let .updateCart(leadUUID, _): return "orders/\(leadUUID)/cart/"
        case let .applyPromocode(promocode): return "/orders/coupons/\(promocode)/"
        }
    }

    var method: Method {
        switch self {
        case .apply: return .post
        case .authorizedApply: return .post
        case .authorizedApplyWithAddress: return .post
        case .getProducts: return .get
        case .getProductDetail: return .get
        case .additionalNomenclature: return .get
        case .getCart: return .get
        case .updateCart: return .put
        case .applyPromocode: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .apply(dto): return .requestJSONEncodable(dto)
        case .authorizedApply: return .requestPlain
        case let .authorizedApplyWithAddress(dto): return .requestJSONEncodable(dto)
        case .getProducts: return .requestPlain
        case .getProductDetail: return .requestPlain
        case .additionalNomenclature: return .requestPlain
        case .getCart: return .requestPlain
        case let .updateCart(_, dto): return .requestJSONEncodable(dto)
        case .applyPromocode: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
