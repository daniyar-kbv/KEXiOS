//
//  PushNotificationsAPI.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Moya

enum PushNotificationsAPI {
    case fcmTokenUpdate
    case fcmTokenLogin(leadUUID: String)
    case fcmTokenCreate
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
        case .fcmTokenUpdate: return .requestPlain
        case .fcmTokenLogin: return .requestPlain
        case .fcmTokenCreate: return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
