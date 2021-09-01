//
//  PushNotificationsAPI.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Moya

enum PushNotificationsAPI {
    case fcmTokenSave(dto: FCMTokenSaveDTO)
    case fcmTokenUpdate(dto: FCMTokenUpdateDTO)
}

extension PushNotificationsAPI: TargetType {
    var baseURL: URL {
        return Constants.URLs.APIBase.dev
    }

    var path: String {
        switch self {
        case .fcmTokenSave: return "/notifications/fbtoken/save/"
        case .fcmTokenUpdate: return "/notifications/fbtoken/update/"
        }
    }

    var method: Method {
        switch self {
        case .fcmTokenSave: return .post
        case .fcmTokenUpdate: return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .fcmTokenSave(dto): return .requestJSONEncodable(dto)
        case let .fcmTokenUpdate(dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
