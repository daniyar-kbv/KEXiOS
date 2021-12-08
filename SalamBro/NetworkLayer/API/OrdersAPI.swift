//
//  OrdersAPI.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Moya

enum OrdersAPI {
    case getAllOrders(page: Int)
    case apply(dto: OrderApplyDTO)
    case authorizedApply(dto: OrderApplyDTO?)
    case additionalNomenclature
    case updateCart(dto: CartDTO)
    case applyPromocode(promocode: String)
    case leadInfo
}

extension OrdersAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.apiBaseURL
    }

    var path: String {
        switch self {
        case .getAllOrders: return "orders/"
        case .apply: return "orders/apply/"
        case .authorizedApply: return "/orders/authorized-apply/"
        case .additionalNomenclature: return "/orders/\(Constants.URLVariables.leadUUID)/additional-nomenclature/"
        case .updateCart: return "orders/\(Constants.URLVariables.leadUUID)/cart/"
        case let .applyPromocode(promocode): return "/orders/coupons/\(promocode)/"
        case .leadInfo: return "/orders/\(Constants.URLVariables.leadUUID)/show/"
        }
    }

    var method: Method {
        switch self {
        case .getAllOrders: return .get
        case .apply: return .post
        case .authorizedApply: return .post
        case .additionalNomenclature: return .get
        case .updateCart: return .put
        case .applyPromocode: return .get
        case .leadInfo: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .getAllOrders(page):
            let params = ["page": page]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case let .apply(dto): return .requestJSONEncodable(dto)
        case let .authorizedApply(dto):
            if let dto = dto { return .requestJSONEncodable(dto) }
            else { return .requestPlain }
        case .additionalNomenclature: return .requestPlain
        case let .updateCart(dto): return .requestJSONEncodable(dto)
        case .applyPromocode: return .requestPlain
        case .leadInfo: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
