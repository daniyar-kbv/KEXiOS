//
//  NotificationsResponse.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Foundation

struct PushNotificationsFCMTokenLoginResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {}
}

struct PushNotificationsFCMTokenUpdateResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {}
}

struct PushNotificationsFCMTokenCreateResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {
        let leadUUID: String
        let fcmToken: String

        enum CodingKeys: String, CodingKey {
            case leadUUID = "lead_uuid"
            case fcmToken = "firebase_token"
        }
    }
}
