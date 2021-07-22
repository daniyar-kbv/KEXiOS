//
//  PushNotificationsDTP.swift
//  SalamBro
//
//  Created by Dan on 7/19/21.
//

import Foundation

struct FCMTokenUpdateDTO: Encodable {
    let fcmToken: String

    enum CodingKeys: String, CodingKey {
        case fcmToken = "firebase_token"
    }
}

struct FCMTokenCreateDTO: Encodable {
    let leadUUID: String
    let fcmToken: String

    enum CodingKeys: String, CodingKey {
        case fcmToken = "firebase_token"
        case leadUUID = "lead_uuid"
    }
}
