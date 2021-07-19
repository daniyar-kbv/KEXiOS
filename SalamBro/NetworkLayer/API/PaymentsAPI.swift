//
//  PaymentsAPI.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Moya

enum PaymentsAPI {
    case myCards
    case createOrder(dto: CreateOrderDTO)
    case createPayment(dto: CreatePaymentDTO)
    case createCardPayment(cardUUID: String)
    case confirm3DSPayment(dto: Create3DSPaymentDTO)
}

extension PaymentsAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .myCards: return "/payments/my-cards/"
        case .createOrder: return "/orders/create/"
        case .createPayment: return "/payments/create-payment/"
        case let .createCardPayment(cardUUID): return "/payments/create-card-payment/\(cardUUID)/"
        case .confirm3DSPayment: return "/payments/confirm-payment/"
        }
    }

    var method: Method {
        switch self {
        case .myCards: return .get
        case .createOrder: return .post
        case .createPayment: return .post
        case .createCardPayment: return .post
        case .confirm3DSPayment: return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .myCards: return .requestPlain
        case let .createOrder(dto): return .requestJSONEncodable(dto)
        case let .createPayment(dto): return .requestJSONEncodable(dto)
        case .createCardPayment: return .requestPlain
        case let .confirm3DSPayment(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
