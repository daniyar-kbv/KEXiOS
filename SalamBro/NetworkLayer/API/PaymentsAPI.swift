//
//  PaymentsAPI.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Moya

enum PaymentsAPI {
    case createOrder(dto: CreateOrderDTO)
    case createPayment(dto: CreatePaymentDTO)
}

extension PaymentsAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .createOrder: return "/orders/create/"
        case .createPayment: return "/payments/create-payment/"
        }
    }

    var method: Method {
        switch self {
        case .createOrder: return .post
        case .createPayment: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .createOrder(dto): return .requestJSONEncodable(dto)
        case let .createPayment(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
