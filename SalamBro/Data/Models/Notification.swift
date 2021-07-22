//
//  Notification.swift
//  SalamBro
//
//  Created by Dan on 7/17/21.
//

import Foundation
import UIKit

class PushNotification {
    var aps: NotificationAps
    var pushType: PushType
    var pushTypeValue: String

    init?(dictionary: [AnyHashable: Any]) {
        guard let apsDict = dictionary["aps"] as? [String: Any],
              let aps = NotificationAps(dictionary: apsDict),
              let pushTypeStr = dictionary["push_type"] as? String,
              let pushType = PushType(rawValue: pushTypeStr),
              let pushTypeValue = dictionary["push_type_value"] as? String
        else {
            print("\(String(describing: Self.self)) failed")
            return nil
        }

        self.aps = aps
        self.pushType = pushType
        self.pushTypeValue = pushTypeValue
    }
}

extension PushNotification {
    enum PushType: String {
        case info = "INFO"
        case promotions = "PROMOTION"
        case orderRate = "ORDER_RATE"
        case orderStatusUpdate = "ORDER_STATUS_UPDATE"
    }
}

class NotificationAps {
    var alert: NotificationAlert

    init?(dictionary: [AnyHashable: Any]) {
        guard let alertDict = dictionary["alert"] as? [AnyHashable: Any],
              let alert = NotificationAlert(dictionary: alertDict)
        else {
            print("\(String(describing: Self.self)) failed")
            return nil
        }
        self.alert = alert
    }
}

class NotificationAlert {
    var body: String
    var title: String

    init?(dictionary: [AnyHashable: Any]) {
        guard let body = dictionary["body"] as? String,
              let title = dictionary["title"] as? String
        else {
            print("\(String(describing: Self.self)) failed")
            return nil
        }
        self.body = body
        self.title = title
    }
}
