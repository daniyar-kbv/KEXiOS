//
//  PaymentsAPI.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Moya

enum PaymentsAPI {
    case myCards
    case deleteCard(uuid: String)
    case createOrder(dto: CreateOrderDTO)
    case createPayment(dto: CreatePaymentDTO)
    case createCardPayment(dto: CardPaymentDTO)
    case confirm3DSPayment(dto: Create3DSPaymentDTO, paymentUUID: String)
    case paymentStatus
}

extension PaymentsAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.apiBaseURL
    }

    var path: String {
        switch self {
        case .myCards: return "/payments/my-cards/"
        case let .deleteCard(uuid): return "/payments/my-cards/\(uuid)/"
        case .createOrder: return "/orders/create/"
        case .createPayment: return "/payments/create-payment/"
        case .createCardPayment: return "/payments/create-card-payment/"
        case let .confirm3DSPayment(_, paymentUUID): return "/payments/confirm-payment/\(paymentUUID)/"
        case .paymentStatus: return "/orders/\(Constants.URLVariables.leadUUID)/status/"
        }
    }

    var method: Method {
        switch self {
        case .myCards: return .get
        case .deleteCard: return .delete
        case .createOrder: return .post
        case .createPayment: return .post
        case .createCardPayment: return .post
        case .confirm3DSPayment: return .put
        case .paymentStatus: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .myCards: return .requestPlain
        case .deleteCard: return .requestPlain
        case let .createOrder(dto): return .requestJSONEncodable(dto)
        case let .createPayment(dto): return .requestJSONEncodable(dto)
        case let .createCardPayment(dto): return .requestJSONEncodable(dto)
        case let .confirm3DSPayment(dto, _): return .requestJSONEncodable(dto)
        case .paymentStatus: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
