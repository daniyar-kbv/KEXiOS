//
//  PushNotificationsAPI.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Moya

enum PushNotificationsAPI {
    case fcmTokenUpdate(dto: FCMTokenUpdateDTO)
    case fcmTokenLogin(leadUUID: String)
    case fcmTokenCreate(dto: FCMTokenCreateDTO)
}

extension PushNotificationsAPI: TargetType {
    var baseURL: URL {
        return devBaseUrl
    }

    var path: String {
        switch self {
        case .fcmTokenUpdate: return "/notifications/fbtoken-update/"
        case let .fcmTokenLogin(leadUUID): return "/notifications/fbtoken-login/\(leadUUID)/"
        case .fcmTokenCreate: return "/notifications/fbtoken-create/"
        }
    }

    var method: Method {
        switch self {
        case .fcmTokenUpdate: return .put
        case .fcmTokenLogin: return .put
        case .fcmTokenCreate: return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .fcmTokenUpdate(dto): return .requestJSONEncodable(dto)
        case .fcmTokenLogin: return .requestPlain
        case let .fcmTokenCreate(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
