//
//  PushNotificationsDTP.swift
//  SalamBro
//
//  Created by Dan on 7/19/21.
//

import Foundation

struct FCMTokenSaveDTO: Codable {
    let fcmToken: String

    enum CodingKeys: String, CodingKey {
        case fcmToken = "firebase_token"
    }
}

struct FCMTokenUpdateDTO: Codable {
    let oldFCMToken: String
    let newFCMToken: String

    enum CodingKeys: String, CodingKey {
        case oldFCMToken = "old_firebase_token"
        case newFCMToken = "new_firebase_token"
    }
}
